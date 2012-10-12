class Event < ActiveRecord::Base

  belongs_to :venue
  belongs_to :class_organiser, :class_name => "Organiser"
  belongs_to :social_organiser, :class_name => "Organiser"
  has_and_belongs_to_many :swing_dates, :uniq => true
  has_and_belongs_to_many :swing_cancellations, :class_name => "SwingDate", :join_table => "events_swing_cancellations", :uniq => true
  
  serialize :date_array
  serialize :cancellation_array
  
  validates :url, format: URI::regexp(%w(http https))
  
  validates_presence_of :event_type, :frequency, :url, :day
  
  validates_format_of :shortname, :with => /^[a-z]*$/, :message => "can only contain lowercase characters (no spaces)"
  validates_length_of :shortname, :maximum => 20
  validates_uniqueness_of :shortname, :allow_nil => true, :allow_blank => true

  validates_numericality_of :course_length, :only_integer => true , :greater_than => 0, :allow_nil => true
  
  validate :cannot_be_weekly_and_have_dates
  validate :will_be_listed
  
  def cannot_be_weekly_and_have_dates
    if frequency == 1 && !dates.empty?
      errors.add(:date_array, "must be empty for weekly events")
    end
  end
  
  def will_be_listed
    unless has_class? || has_social?
      errors[:base] << ("Events must have either a Social or a Class, otherwise they won't be listed!")
    end
  end

  # display constants:
  NOTAPPLICABLE = "n/a"
  UNKNOWN_DATE = "Unknown"
  UNKNOWN_VENUE = "Venue Unknown"
  UNKNOWN_ORGANISER = "Unknown"
  WEEKLY = "Weekly"
  SEE_WEB = "(See Website)"

  #########
  ## TEMP #
  #########
  
  # Convert the old, fragile way of storing dates (serialised as an array) into the new one (stored in a table)
  def modernise
    self.date_array = self[:date_array].collect{|ds| ds.to_date.to_s}.join(", ") unless Event.empty_date_string(self[:date_array])
    self.cancellation_array = self[:cancellation_array].collect{|ds| ds.to_date.to_s}.join(", ") unless Event.empty_date_string(self[:cancellation_array])
  end
    
  # ----- #
  # Venue #
  # ----- #
  
  def blank_venue
    return SEE_WEB unless url.nil?
    return UNKNOWN_VENUE
  end
  
  # We shouldn't have any blank fields, but if we do, then display as much as possible:
  def venue_name
    if venue.nil? || venue.name.nil?
      blank_venue
    else
      venue.name
    end
  end
  
  def venue_area
    if venue.nil? || venue.area.nil?
      blank_venue
    else
      venue.area
    end
  end

  # --------- #
  # Frequency #
  # --------- #
  
  def frequency_text
    case frequency
      when 0 then "One-off or intermittent"
      when 1 then "Weekly"
      when 2 then "Fortnightly"
      when 4..5 then "Monthly"
      when 8 then "Bi-Monthly"
      when 26 then "Twice-yearly"
      when 52 then "Yearly"
      when 1..100 then "Every #{frequency} weeks"
      else "Unknown"
    end
  end
  
  def one_off?
    frequency==0
  end
  
  # ---------- #
  # Event Type #
  # ---------- #
  
  EVENT_TYPES=[
    'school',
    'dance_club',
    'vintage_club',
    'gig',
    'festival'
  ]
 
  def is_gig?
    event_type == "gig"
  end  
  
  # scopes to get different types of event:
  scope :classes, where(has_class: true)
  scope :socials, where(has_social: true)
  scope :weekly, where(frequency: 1)
  scope :weekly_or_fortnightly, where(frequency: [1,2])
    
  scope :gigs, where(:event_type => "gig")
  scope :non_gigs, where("event_type != ?", "gig")
  
  scope :active, where("last_date IS NULL OR last_date > ?", Date.local_today)
  scope :ended, where("last_date IS NOT NULL AND last_date < ?", Date.local_today)
  
  scope :listing_classes, active.weekly_or_fortnightly.classes
  scope :listing_classes_on_day, lambda { |day| listing_classes.where(day: day) }
  scope :listing_classes_at_venue, lambda { |venue| listing_classes.where(venue_id: venue.id) }
  scope :listing_classes_on_day_at_venue, lambda { |day, venue| listing_classes_on_day(day).where(venue_id: venue.id) }
  
  # For making sections in the Events editing screens:
  scope :current, active.non_gigs
  scope :archived, ended.non_gigs


  # ----- #
  # Dates #
  # ----- #

  #TODO: find a way of DRYing this up...
  def dates
    swing_dates.collect{|sd| sd.date}
  end
  
  def add_date(new_date)
    self.swing_dates << SwingDate.find_or_initialize_by_date(new_date)
  end
    
  def dates=(array_of_new_dates)
    self.swing_dates = []
    array_of_new_dates.each{ |nd| add_date(nd) }
  end
  
  def date_array=(date_string)
    self.dates = Event.parse_date_string(date_string)
  end
  
  
  def cancellations
    swing_cancellations.collect{|sc| sc.date}
  end
  
  def cancellations=(array_of_new_cancellations)
    self.swing_cancellations = []
    array_of_new_cancellations.each{ |nc| add_cancellation(nc) }
  end
  
  def add_cancellation(new_cancellation)
    self.swing_cancellations << SwingDate.find_or_initialize_by_date(new_cancellation)
  end
  
  def cancellation_array=(date_string)
    self.cancellations = Event.parse_date_string(date_string)
  end
  
  def self.empty_date_string(date_string)
    date_string.nil? || date_string.empty? || date_string == UNKNOWN_DATE || date_string == WEEKLY
  end
  
  #TODO - move to better_dates.rb?
  def self.parse_date_string( date_string )
    return [] if empty_date_string(date_string)
    
    output_dates = []
    
    date_string.split(',').each do |ds|
      begin
        date = ds.to_date
        #to_date is defined in config/initializers/better_dates.rb, which extends String.
      rescue Exception => msg
        #TODO
      else
        output_dates << date
      end
    end
    return output_dates 
  end
  
  # READ METHODS #
  
  def date_array(future= false)
    return_array_of_dates(dates, future)
  end

  def cancellation_array(future= false)
    return_array_of_dates(cancellations, future)
  end
  
  private
  
  # Given an array of dates, return an appropriately filtered array
  def return_array_of_dates(input_dates, future=true)
    return [] if input_dates.nil? || input_dates.empty?
    
    input_dates = filter_future(input_dates) if future
    input_dates
  end
  
  # Given an array of dates, return only those in the future
  def filter_future(input_dates)
    #TODO - should be able to simply replace this with some variant of ".future?", but need to test
    input_dates.select{ |d| d >= Date.local_today}
  end
  
  public
  
  
  # PRINT METHODS #
  
  def print_dates
    print_date_array
  end
   
  def print_dates_rows
    print_date_array(",\n")
  end
  
  def print_cancellations
    print_cancellation_array
  end
   
  def pretty_cancelled_dates
    print_cancellation_array(', ', :short_date, true)
  end
   
  def cancelled_dates_rows
    print_cancellation_array(",\n")
  end
  
  # -- Helper functions for Print:
  
  def print_date_array(sep=',', format= :uk_date, future= false )
    # Weekly events don't have dates 
    return WEEKLY if frequency == 1
    print_array_of_dates(dates, sep, format, future)
  end
  
  def print_cancellation_array(sep=',', format= :uk_date, future= false )
    print_array_of_dates(cancellations, sep, format, future)
  end
  
  private
  
  # Given an array of dates, return a formatted string
  def print_array_of_dates(input_dates, sep=',', format= :uk_date, future= false )
    return UNKNOWN_DATE if input_dates.nil? || input_dates.empty?
    
    input_dates = filter_future(input_dates) if future
    input_dates.collect{ |d| d.to_s(format) }.join(sep)
  end
   
  public

  # COMPARISON METHODS #

  # Are all the dates for the event in the past?
  def out_of_date
    return true if date_array == UNKNOWN_DATE
    out_of_date_test(Date.local_today)
  end
  
  # Does an event not have any dates not already shown in the socials list?
  def near_out_of_date
    out_of_date_test(Date.local_today + INITIAL_SOCIALS)
  end
  
  private
  
  # Helper function for comparing event dates to a reference date
  def out_of_date_test(comparison_date)
    return false if infrequent_in_date # Really infrequent events shouldn't be considered out of date until they are nearly due.
    return false if frequency==1 # Weekly events shouldn't have date arrays...
    
    return true if dates.empty? || dates.nil?
    return false if latest_date >= comparison_date
    true
  end
  
  public
  
  
  # For infrequent events (6 months or less), is the next expected date (based on the last known date)
  # more than 3 months away?
  def infrequent_in_date
    return false if dates.nil?
    return false if frequency < 26
    
    expected_date = latest_date + frequency.weeks #Belt and Braces: the date array should already be sorted.
    expected_date > Date.local_today + 3.months
  end
  
  # Is the event new? (probably only applicable to classes)
  def new?
    return false if first_date.nil?
    first_date > Date.local_today - 1.month
  end
  
  # Has the first instance of the event happened yet?
  def started?
    return false if first_date.nil?
    first_date < Date.local_today
  end
  
  # Has the last instance of the event happened?
  def ended?
    return false if last_date.nil?
    last_date < Date.local_today
  end
  
  def intermittent?
    frequency == 0 && last_date != latest_date
  end
  
  def one_off?
    frequency == 0 && last_date == latest_date && first_date == latest_date
  end
  
  def infrequent?
    frequency > 26
  end
  
  def less_frequent?
    frequency == 0 || frequency >= 4
  end 
  
  
  # What's the Latest date in the date array
  # N.B. Assumes the date array is sorted!
  def latest_date
    swing_dates.maximum(:date)
  end
  
  # for repeating events - find the next and previous dates
  def next_date
    return unless frequency == 1
    return Date.local_today if day = Event.weekday_name(Date.local_today)
    return Date.local_today.next_week(day.downcase.to_sym)
  end
  
  def prev_date
    return unless frequency == 1
    return Date.local_today if day = Event.weekday_name(Date.local_today)
    #prev_week doesn't seem to be implemented...
    return (next_date - 7.days)
  end
  
  
  # is/was/will the event active on a particular date?
  def active_on(date)
    (first_date.nil? || first_date <= date) &&
    (last_date.nil? || last_date >= date)
  end
  
  scope :active_on, lambda{ |date| where("(first_date IS NULL OR first_date <= ?) AND (last_date IS NULL OR last_date >= ?)", date, date) }
  
  
  ###########
  # ACTIONS # 
  ###########
  
  def archive!
    return false if !last_date.nil? && last_date < Date.local_today
    # If there's already a last_date in the past, then the event should already be archived!
    
    if frequency == 1
      self[:last_date] = prev_date
    elsif dates.nil?
      self[:last_date] = Date.new # Earliest possible ruby date
    else
      self[:last_date] = latest_date
    end
    
    return true if self.save!
  end
  
  
  #################
  # CLASS METHODS # 
  #################
  
  # Allows urls like "/event/blackcotton"
  def self.findevent(input)
    # If to_i is called on a character string, 0 is returned
    if input.to_i == 0
      e = first(:conditions => ["shortname = ?",input])
      if e.nil?
        raise ActiveRecord::RecordNotFound, "Couldn't find Event with Shortname=\"#{input}\""
      else 
        e
      end
    else
      find(input)
    end
  end

  # Find the datetime of the most recently updated event
  def self.last_updated_datetime
    #if the db is empty, return the beginning of the epoch:
    return Time.at(0) if self.first.nil?

    maximum(:updated_at)
  end
    

  # TODO: should put these somewhere extending Date class
  def self.weekday_name(d) 
    Date::DAYNAMES[d.wday]
  end

  def self.socials_dates(start_date, venue=nil) 
    #build up an array of events occuring on each date
    output = []
    
    listing_dates(start_date).each do |date|
      socials_on_date = socials_on_date(date, venue)
      output << [date, socials_on_date, cancelled_events_on_date(date)] if socials_on_date
    end
    
    return output
  end 
  
  def self.socials_on_date(date, venue=nil)
    day = weekday_name(date)
    swing_date = SwingDate.find_by_date(date)
    
    if venue 
      socials_on_that_date = weekly.socials.where(venue_id: venue.id).active_on(date).where(day: day)
      socials_on_that_date += swing_date.events.socials.where(venue_id: venue.id) if swing_date
    else  
      socials_on_that_date = weekly.socials.includes(:venue).active_on(date).where(day: day)  
      socials_on_that_date += swing_date.events.socials.includes(:venue) if swing_date
    end
    
    return if socials_on_that_date.blank?
    
    socials_on_that_date.sort!{|a,b| a.title <=> b.title}
  end
  
  def self.cancelled_events_on_date(date)
    swing_date = SwingDate.find_by_date(date)
    swing_date.cancelled_events.collect{ |e| e.id } if swing_date
  end
  
  def self.listing_dates(start_date)
    end_date = start_date + (INITIAL_SOCIALS-1)
    (start_date..end_date).to_a
  end
  
  
end

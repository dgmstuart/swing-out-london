class Event < ActiveRecord::Base

  belongs_to :venue
  belongs_to :organiser
  has_and_belongs_to_many :swing_dates, :uniq => true
  has_and_belongs_to_many :swing_cancellations, :class_name => "SwingDate", :join_table => "events_swing_cancellations", :uniq => true
  
  serialize :date_array
  serialize :cancellation_array
  
  validates_presence_of :event_type, :frequency, :url, :day
  
  validates_format_of :shortname, :with => /^[a-z]*$/, :message => "can only contain lowercase characters (no spaces)"
  validates_length_of :shortname, :maximum => 20
  validates_uniqueness_of :shortname, :allow_nil => true, :allow_blank => true

  validates_numericality_of :course_length, :only_integer => true , :greater_than => 0, :allow_nil => true

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
  
  CLASS_TYPES = ['class', 'class with social']
  SOCIAL_TYPES = ['social', 'social with class', 'class with social', 'vintage club', 'gig', 'festival']
  HAS_CLASS_TYPES = ['class', 'class with social', 'social with class']
  
  def self.event_types
    (CLASS_TYPES + SOCIAL_TYPES).uniq
  end
  
  def is_class?
    CLASS_TYPES.include?event_type
  end
  
  def is_social?
    SOCIAL_TYPES.include?event_type
  end
  
  def is_gig?
    event_type == "gig"
  end  
  
  def has_class?
    HAS_CLASS_TYPES.include?event_type
  end

  # ----- #
  # Dates #
  # ----- #

  def dates
    swing_dates.collect{|sd| sd.date}
  end
  
  def cancellations
    swing_cancellations.collect{|sc| sc.date}
  end

  # WRITE METHODS #
  
  def date_array=(date_string)
    self.swing_dates = Event.parse_date_string(date_string)
  end

  def cancellation_array=(date_string)
    self.swing_cancellations = Event.parse_date_string(date_string)
  end
  
  def self.empty_date_string(date_string)
    date_string.nil? || date_string.empty? || date_string == UNKNOWN_DATE || date_string == WEEKLY
  end
  
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
        output_dates << SwingDate.find_or_initialize_by_date(date)
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
  def filter_future(date_array)
    date_array.select{ |d| d >= Date.local_today}
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
  
  # For infrequent events (6 months or less), is the next expected date (based on the last known date)
  # more than 3 months away?
  def infrequent_in_date
    return false if date_array.nil?
    return false if frequency < 26
    expected_date = date_array.sort.reverse.first + frequency.weeks #Belt and Braces: the date array should already be sorted.
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
  
  # Is the event currently running?
  def active?
    started? && !ended?
  end
  def inactive?
    !started? || ended?
  end
  
  def current?
    !ended? && !is_gig?
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
    date_array.last
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
  
  private
  
  # Helper function for comparing event dates to a reference date
  def out_of_date_test(comparison_date)
    return false if infrequent_in_date # Really infrequent events shouldn't be considered out of date until they are nearly due.
    return false if frequency==1 # Weekly events shouldn't have date arrays...
    
    return true if date_array.empty?
    return false if latest_date >= comparison_date
    true
  end
  
  public
  
  ###########
  # ACTIONS # 
  ###########
  
  def archive!
    return false if !last_date.nil? && last_date < Date.local_today
    # If there's already a last_date in the past, then the event should already be archived!
    
    if frequency == 1
      self[:last_date] = prev_date
    elsif date_array.nil?
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
  

  # Helper methods to get different types of event:
  def self.classes(*args)
    self.where(:event_type => CLASS_TYPES).order("title").all(*args)
  end

  def self.socials(*args)
    self.where(:event_type => SOCIAL_TYPES).order("title").all(*args)
  end
  
  def self.gigs(*args)
    self.all({:conditions => ["event_type = ?","gig"]},*args)
  end

  # Get a list of classes, excluding those which have ended
  # TODO: not very DRY
  def self.active_classes(*args)
    self.order("title ASC").all(*args).select{ |e| e.is_class? && !e.ended? }
  end
  
  
  # Get lists of current and archived events
  def self.current_events(*args)
    self.all(*args).select{ |e| e.current? }
  end

  def self.archive_events(*args) 
    self.all(*args).select{ |e| e.ended? && !e.is_gig?}
  end
  
  
    
  
  
  # Get a list of socials with their associated dates
  def self.socials_dates(start_date)
    @start_date = start_date
    # Concatenate the list of dates of weekly and other socials in the period,
    # and sort by date 

    merge_dates_hashes(weekly_socials_dates, other_socials_dates).sort
  end
  
  # Get the socials which are happening today:
  def self.socials_today
    dates_array = self.socials_dates(Date.local_today)
    # Get the list of events
    return dates_array[0][1] unless dates_array == []
    return []
  end

  # Find the datetime of the most recently updated event
  def self.last_updated_datetime
    #if the db is empty, return the beginning of the epoch:
    return Time.at(0) if self.first.nil?

    self.order('updated_at DESC').first.updated_at
  end
    

  # TODO: should put these somewhere extending Date class
  def self.weekday_name(d) 
    Date::DAYNAMES[d.wday]
  end

  private

  # NOTE: this is a HORRIBLY inefficient way to build up the array, involving multiple passes and sorts. There must be a better way...


  # Get a hash of all dates in the selected range, and the list of all weekly socials occuring on that date
  def self.weekly_socials_dates
    #get an array of all the dates under consideration:
    date_day_array = date_array.collect { |d| [d,weekday_name(d)] } #TODO: forget about matching on weekday names - just use numbers

    #get the list of weekly socials
    weekly_socials = self.socials(:conditions => { :frequency => 1 })

    #build up a hash of events occuring on each date
    date_socials_hash = {}
    date_day_array.each do |date,day| 
      socials_on_that_day =  weekly_socials.select{ |s| s.day == day && s.active_on(date)}
      date_socials_hash.merge!( {date => socials_on_that_day} ) unless socials_on_that_day.empty?
    end

    #output is of form { date1 => [array of weekly socials occuring on date1], ... }

    return date_socials_hash
  end


  # Get a hash of all dates in the selected range, and the list of all non - weekly socials occuring on that date
  def self.other_socials_dates

    #get the list of non-weekly socials
    non_weekly_socials = self.socials.select {|s| s.frequency != 1 } #need to select because of negative condition

    #build up a hash of events occuring on each date
    date_socials_hash2 = {}
    date_array.each do |date|
      socials_on_that_day =  non_weekly_socials.select{ |s| s.date_array.include?(date) }
      date_socials_hash2.merge!( {date => socials_on_that_day} ) unless socials_on_that_day.empty?
    end

    #output is of form { date1 => [array of monthly socials occuring on date1], ... }

    return date_socials_hash2
  end


  # merge two hashes of dates and socials, concatenating the lists of dates
  def self.merge_dates_hashes(hash1,hash2)
    hash1.merge(hash2) do |key, val1, val2| 
      #have two sorted segments, but need to sort the result...
      (val1 + val2).sort{|a,b| a.title <=> b.title}
    end
  end  

  def self.date_array
    end_date = @start_date + (INITIAL_SOCIALS-1)
    (@start_date..end_date).to_a
  end

end

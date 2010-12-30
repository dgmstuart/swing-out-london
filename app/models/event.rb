class Event < ActiveRecord::Base

  has_many :activities
  belongs_to :venue
  belongs_to :organiser
  
  default_scope :order => 'title ASC' #sets default search order
  
  serialize :date_array
  serialize :cancellation_array
  
  validates_presence_of :title

  # display constants:
  NOTAPPLICABLE = "n/a"
  UNKNOWN_DATE = "Unknown"
  UNKNOWN_VENUE = "Venue Unknown"
  UNKNOWN_ORGANISER = "Unknown"
  WEEKLY = "Weekly"
  SEE_WEB = "(See Website)"

  def class_style
    return NOTAPPLICABLE if read_attribute(:class_style).nil?
    self[:class_style]
  end

  # ----- #
  # Venue #
  # ----- #
  
  def blank_venue
    return SEE_WEB unless url.nil?
    return UNKNOWN_VENUE
  end
  
  def venue_name
    if venue.nil? || venue.name.nil?
      blank_venue
    else
      venue.name
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
  SOCIAL_TYPES = ['social', 'social with class', 'class with social', 'vintage club', 'gig']
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
  
  def has_class?
    HAS_CLASS_TYPES.include?event_type
  end

  # ----- #
  # Dates #
  # ----- #

  # WRITE METHODS #
  
  def date_array=(date_string)
    self[:date_array]=parse_date_string(date_string)
  end

  def cancellation_array=(date_string)
    self[:cancellation_array]=parse_date_string(date_string)
  end
  
  #TODO: the following should be elsewhere? i.e. not in the Event class
  private
  
  # Interpret a comma separated string as dates:
  def parse_date_string( date_string )
    
    if date_string.empty? || date_string.nil? || date_string == UNKNOWN_DATE || date_string == WEEKLY # These are equivalent to empty TODO: REQUIRED?
      string_array = [] 
    else
      string_array = date_string.split(',')
    end

    string_array.collect { |d| uk_date_from_string(d) }.sort
  end

  # TODO: should put this somewhere extending Date class
   def uk_date_from_string(date_string)    
     #HACK - to get around stupid date parsing not recognising UK dates
     date_part_array = Time.parse(date_string)
     return Date.new(date_part_array[0], date_part_array[2], date_part_array[1]) unless (date_part_array[0].nil? || date_part_array[2].nil? || date_part_array[1].nil?)
     logger.warn "WARNING: Bad date found: '#{date_string}' - ignored"
     return
   end
  
  public
  
  # READ METHODS #
  
  def date_array(future= false)
    return_array_of_dates(self[:date_array], future)
  end

  def cancellation_array(future= false)
    return_array_of_dates(self[:cancellation_array], future)
  end
  
  private
  
  # Given an array of dates, return an appropriately filtered array
  def return_array_of_dates(input_dates, future)
    return [] if input_dates.nil? || input_dates.empty?
    
    input_dates = filter_future(input_dates) if future
    input_dates
  end
  
  # Given an array of dates, return only those in the future
  def filter_future(date_array)
    date_array.select{ |d| d >= Date.today}
  end
  
  public
  
  
  # PRINT METHODS #
  
  def dates
    print_date_array
  end
   
  def dates_rows
    print_date_array(",\n")
  end
  
  def cancelled_dates
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
    print_array_of_dates(self[:date_array], sep, format, future)
  end
  
  def print_cancellation_array(sep=',', format= :uk_date, future= false )
    print_array_of_dates(self[:cancellation_array], sep, format, future)
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
    out_of_date_test(Date.today)
  end
  
  # Does an event not have any dates not already shown in the socials list?
  def near_out_of_date
    out_of_date_test(Date.today + INITIAL_SOCIALS)
  end
  
  # For infrequent events (6 months or less), is the next expected date (based on the last known date)
  # more than 3 months away?
  def infrequent_in_date
    return false if date_array.nil?
    return false if frequency < 26
    expected_date = date_array.sort.reverse.first + frequency.weeks #Belt and Braces: the date array should already be sorted.
    expected_date > Date.today + 3.months
  end
  
  # Is the event new? (probably only applicable to classes)
  def new?
    return false if first_date.nil?
    first_date > Date.today - NEW_DAYS
  end
  
  # Has the first instance of the event happened yet?
  def started?
    return false if first_date.nil?
    first_date < Date.today
  end
  
  # Has the last instance of the event happened?
  def ended?
    return false if last_date.nil?
    last_date < Date.today
  end
  
  # Is the event currently running?
  def active?
    started? && !ended?
  end
  def inactive?
    !started? || ended?
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
    date_array.each {|d| return false if d > comparison_date }
    true
  end
  
  public
  
  #################
  # CLASS METHODS # 
  #################

  # Helper methods to get different types of event:
  def self.classes(*args)
    self.all(*args).select{|e| e.is_class? }
  end

  def self.socials(*args)
    self.all(*args).select{|e| e.is_social? }
  end

  # Get a list of classes, excluding those which have ended
  # TODO: not very DRY
  def self.active_classes
    self.all.select{ |e| e.is_class? && !e.ended? }
  end  
    

  # Get a list of socials with their associated dates
  def self.socials_dates(end_date)
    @end_date = end_date
    # Concatenate the list of dates of weekly and other socials in the period,
    # and sort by date 

    merge_dates_hashes(weekly_socials_dates, other_socials_dates).sort
  end

  # Find the datetime of the most recently updated event
  def self.last_updated_datetime
    self.first( :order => 'updated_at DESC').updated_at
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
    (Date.today..@end_date).to_a
  end

end

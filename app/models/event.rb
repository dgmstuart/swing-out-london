class Event < ActiveRecord::Base

  has_many :activities
  belongs_to :venue
  belongs_to :organiser
  
  default_scope :order => 'title ASC' #sets default search order
  
  serialize :date_array
  serialize :cancellation_array
  
  validates_presence_of :title

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
  
  # ---------- #
  # Event Type #
  # ---------- #
  
  CLASS_TYPES = ['class', 'class with social']
  SOCIAL_TYPES = ['social', 'social with class', 'class with social', 'vintage club']
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

  def date_array=(date_string)
    self[:date_array]=DateArray.parse(date_string)
  end

  def cancellation_array=(date_string)
    self[:cancellation_array]=DateArray.parse(date_string)
  end

  def date_array(sep=nil, format= :uk_date, future= false)
    # Weekly events don't have dates 
    return WEEKLY if frequency == 1

    DateArray.new(self[:date_array]).output(sep, format, future) 
  end

  def cancellation_array(sep=nil, format= :uk_date, future= true)
    DateArray.new(self[:cancellation_array]).output(sep, format, future) 
  end

  def dates
    date_array(', ')
  end
   
  def dates_rows
    date_array(",\n")
  end
  
  def cancelled_dates
    cancellation_array(', ')
  end
   
  def pretty_cancelled_dates
    cancellation_array(', ', :pretty_date, true)
  end
   
  def cancelled_dates_rows
    cancellation_array(",\n")
  end
   

  # Are all the dates for the event in the past?
  def out_of_date
    return true if date_array == UNKNOWN_DATE
    out_of_date_test(Date.today)
  end
  
  # Does an event not have any dates not already shown in the socials list?
  def near_out_of_date
    out_of_date_test(Date.today + INITIAL_SOCIALS)
  end
  
  private
  
  # Helper function for comparing event dates to a reference date
  def out_of_date_test(comparison_date)
    return false if date_array == WEEKLY
    date_array.each {|d| return false if d > comparison_date }
    true
  end
  
  public
  
  #################
  # CLASS METHODS # 
  #################

  # Helper methods to get different types of event:
  def self.classes(*args)
    self.find(:all, *args).select{|e| e.is_class? }
  end

  def self.socials(*args)
    self.find(:all, *args).select{|e| e.is_social? }
  end

  # Get a list of socials with their associated dates
  def self.socials_dates(end_date)
    @end_date = end_date
    # Concatenate the list of dates of weekly and other socials in the period,
    # and sort by date 

    merge_dates_hashes(weekly_socials_dates, other_socials_dates).sort
  end

  # TODO: should put these somewhere extending Date class
  def self.weekday_name(d) 
    Date::DAYNAMES[d.wday]
  end
  
  # TODO: should put these somewhere extending Date class
  def uk_date_from_string(date_string)    
    #HACK - to get around stupid date parsing not recognising UK dates
    date_part_array = ParseDate.parsedate(date_string)
    return Date.new(date_part_array[0], date_part_array[2], date_part_array[1]) unless (date_part_array[0].nil? || date_part_array[2].nil? || date_part_array[1].nil?)
    logger.warn "WARNING: Bad date found: '#{date_string}' - ignored"
    return
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
      socials_on_that_day =  weekly_socials.select{ |s| s.day == day }
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

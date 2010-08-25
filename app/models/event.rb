class Event < ActiveRecord::Base

  has_many :activities
  belongs_to :venue
  belongs_to :organiser
  
  default_scope :order => 'title ASC' #sets default search order
  
  serialize :date_array
  
  validates_presence_of :title


  NOTAPPLICABLE = "n/a"
  UNKNOWN_DATE = "Unknown"
  UNKNOWN_VENUE = "Venue Unknown"
  UNKNOWN_ORGANISER = "Unknown"
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

  #interpret a comma separated strings as dates
  def date_array=(date_string)
    if date_string == UNKNOWN_DATE #this is equivalent to empty
      string_array = [] 
    else
      string_array = date_string.split(',')
    end
    
    self[:date_array]= string_array.collect { |d| uk_date_from_string(d) }.sort
  end
  
  def date_array(sep=nil)
    # Weekly events don't have dates
    return NOTAPPLICABLE if frequency == 1
    
    if sep.nil?
      #return an array
      return [] if self[:date_array].nil? || self[:date_array].empty?
      self[:date_array]
    else  
      #return a string
      return UNKNOWN_DATE if self[:date_array].nil? || self[:date_array].empty?
      self[:date_array].collect{ |d| d.to_s(:uk_date) }.join(sep) unless sep.nil?
    end
  end
   
  def dates
    date_array(', ')
  end
  
  def dates_rows
    date_array(",\n")
  end
  
  def next_date
    date_array[0].to_s(:uk_date)
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
    return false if date_array == NOTAPPLICABLE
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

  def uk_date_from_string(date_string)    
    #HACK - to get around stupid date parsing not recognising UK dates
    date_array = ParseDate.parsedate(date_string)
    return Date.new(date_array[0], date_array[2], date_array[1]) unless (date_array[0].nil? || date_array[2].nil? || date_array[1].nil?)
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

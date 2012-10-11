class Venue < ActiveRecord::Base
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => false
   
  require 'geokit'
  include Geokit::Geocoders
  
  has_many :events
  
  scope :all_with_classes_listed, where(:id => Event.listing_classes.select("distinct venue_id"))
  scope :all_with_classes_listed_on_day, lambda { |day| where(:id => Event.listing_classes_on_day(day).select("distinct venue_id")) }
  
  validates_presence_of :name, :area
  validates :website, format: URI::regexp(%w(http https))

  before_validation do
    if lat.nil? || lng.nil?
      geocoded = self.geocode!
      errors.add :lat, "The address information could not be geocoded. 
        Please check the address information or manually enter 
        latitude and longitude" if !geocoded
    end
  end


  UNKNOWN_AREA = "Unknown Area"
  UNKNOWN_POSTCODE = "???"
  
 # TODO: legacy
  def compass_text
    title = case compass
      when "C" then "Central London" 
      when "N" then "North London"
      when "S" then "South London"
      when "E" then "East London"
      when "W" then "West London"
      when "NE" then "North East London"
      when "NW" then "North West London"
      when "SE" then "South East London"
      when "SW" then "South West London"
    else 
      UNKNOWN_AREA
    end  
    return title
  end
  
  
  def outward_postcode
    return UNKNOWN_POSTCODE if postcode.nil? || postcode.empty?
    
    # Match the first part of the postcode:
    regexp = /[A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]?/
    regexp.match(postcode.upcase)[0]
  end
  
  def name_and_area
    name + ' - ' + area
  end 
  
  # Are there any active events associated with this venue?
  def all_events_out_of_date?
    events.all?{|e| e.out_of_date}
  end
  
  def all_events_nearly_out_of_date?
    events.all?{|e| e.near_out_of_date}
  end
  
  
  # Map-related methods:
  def position
    [lat,lng] unless lat.nil? || lng.nil?
  end
  
  def coordinates
    "[ #{lat.to_s}, #{lng.to_s} ]"
  end
  
  
  def geocode
    #TODO - split out the "London" part from addresses (populate it as default) so that we can search "postcode, London" here
    GoogleGeocoder.geocode(postcode) unless postcode.nil?
  end
  
  def geocode!
    location = geocode
    
    if !location.nil? && location.success
      self[:lat]=location.lat
      self[:lng]=location.lng
      return true
    end

    return false
  end
  
  def self.geocode_all
    bulk_geocode
  end
  
  def self.geocode_all_non_geocoded
    bulk_geocode(non_geocoded)
  end
  
  def self.geocoded
    all.select{ |v| !sv.position.nil?}
  end
  
  def self.non_geocoded
    all.select{ |v| v.position.nil?}
  end
  
  
  def self.bulk_geocode(venuelist=all)
    failed_save = []
    failed_geocode = []

    venuelist.each do |venue|
      
      if venue.geocode!
        failed_save << venue unless venue.save
      else
        failed_geocode << venue
      end
      sleep 0.05 # need to sleep so that Google doesn't get all overwhelmed
    end  
 
    if failed_save.empty? && failed_geocode.empty?
      return true
    else
      return {:failed_save => failed_save, :failed_geocode => failed_geocode}
    end

  end
  
end

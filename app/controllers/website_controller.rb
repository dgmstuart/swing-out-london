class WebsiteController < ApplicationController
  
  require 'rubygems'
  require 'twitter'
  require 'geokit'
  
  include Geokit::Geocoders
  
  before_filter :get_updated_times
  
  def index
    @classes = Event.active_classes
    @socials_dates = Event.socials_dates(Date.local_today + (INITIAL_SOCIALS-1))  
    
    # The call to the twitter api fails if it can't reach twitter, so we need to handle this
    begin
      @latest_tweet = Twitter.user_timeline("swingoutlondon").first
    rescue Exception => msg
      @latest_tweet = nil
      logger.error "[ERROR]: Failed to get latest tweet with message '#{msg}'"
    end
  end
  
  #TODO: move into a different file?
  def get_updated_times
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
    @last_updated_datetime = Event.last_updated_datetime
  end
  
  def lindy_map
    @map = Cartographer::Gmap.new( 'map', :type => :roadmap )
    @map.center = [51.51985,-0.06729]
    @map.zoom = 12
    @map.showtubes = (params[:tubes]=="y")
    @map.controls << :type
    @map.controls << :large
    @map.controls << :overview
    
    @icon = Cartographer::Gicon.new
    @map.icons << @icon
    
    Venue.active_venues.each do |venue|
    #[Venue.first].each do |venue|
      sleep 0.1
      location = GoogleGeocoder.geocode(venue.postcode)
      if location.success
        @map.markers << Cartographer::Gmarker.new(
          :name => "venue_#{venue.id}",
          :title => venue.name,
          :position => [location.lat,location.lng],
          :info_window_url => venue_map_info_url(venue.id),
          :icon => @icon
        )
      end
    end
    
    render :layout => 'map'
  end
  
  def venue_map_info
    @venue = Venue.find(params[:id])
    render :layout => false
  end
  
end

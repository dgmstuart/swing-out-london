class WebsiteController < ApplicationController  
  require 'rubygems'
  require 'twitter'
  
  before_filter :set_cache_control_on_static_pages, only: [:about,:listings_policy]
  # caches_action :index, :layout => true, :expires_in => 1.hour
  
  def index
    # Varnish will cache the page for 3600 seconds = 1 hour:
    # response.headers['Cache-Control'] = 'public, max-age=3600'
    
    @last_updated_datetime = Event.last_updated_datetime
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
    @today = today
    
    @tweet = Tweet.message
    
    @classes = Event.listing_classes.includes(:venue, :organiser, :swing_cancellations)
    @socials_dates = Event.socials_dates(@today)
    
    # @ad_type = :square_ads
    @foo = { image_url: "http://placehold.it/150",
                ad_url: "http://foo.bar.com", 
                 title: "Foobar!" }
  end
  
  private
  
  def set_cache_control_on_static_pages
    # Varnish will cache the page for 43200 seconds = 12 hours:
    response.headers['Cache-Control'] = 'public, max-age=43200'
  end
end

class WebsiteController < ApplicationController
  
  require 'rubygems'
  require 'twitter'
  
  before_filter :get_updated_times
  before_filter :set_cache_control_on_static_pages, only: [:about,:listings_policy]
  #caches_action :index
  
  def index
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    @classes = Event.active.weekly_or_fortnightly.classes.includes(:venue, :organiser, :swing_cancellations)
    
    if (Date.local_today.midnight)  > Time.local_now.ago(4.hours)
      # Would be great to just use 4.hours.ago, but timezones would screw it up??
      @today = Date.local_yesterday
    else
      @today = Date.local_today
    end
    
    @socials_dates = Event.socials_dates(@today)  
    
    # The call to the twitter api fails if it can't reach twitter, so we need to handle this
    begin
      # Cache tweets for 10 minutes, timeout after 2 seconds      
      @latest_tweet = APICache.get('latest_tweet', :cache => 600, :timeout => 2) do
        begin
          logger.info "[INFO]: retrieving Twitter message from twitter instead of the cache"
          # Memcached can't store a Hashie::Mash object, so we need to use a normal hash:
          Twitter.user_timeline("swingoutlondon").first.to_hash
        rescue Exception => msg   
          logger.error "[ERROR]: Failed to get latest tweet with message '#{msg}'"
          raise APICache::InvalidResponse
        end
      end
    rescue Dalli::RingError => e
         logger.error "[ERROR]: Dalli::RingError - MemCachier isn't available? #{e}'"
    rescue => e
      # Catch-all: so that the site doesn't crash when caching breaks
      logger.error "[ERROR]: #{e.class} - #{e.message}" 
      e.backtrace.each { |line| logger.error line }
    end
      
  end
  
  #TODO: move into a different file?
  def get_updated_times
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
    @last_updated_datetime = Event.last_updated_datetime
  end
  
  private
  
  def set_cache_control_on_static_pages
    # Varnish will cache the page for 43200 seconds = 12 hours:
    response.headers['Cache-Control'] = 'public, max-age=43200'
  end
end

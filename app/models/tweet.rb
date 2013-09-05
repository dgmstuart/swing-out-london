class Tweet < ActiveRecord::Base    
  def self.message
    begin
      # Cache tweets for 30 minutes, timeout after 1 second, use cached data for up to a day
      message = APICache.get('latest_tweet', :cache => 1800, :timeout => 1, :valid => 86400) do
        logger.info "[INFO]: Attempting to retrieving Twitter message from twitter instead of the cache"
        get_message(APICache::CannotFetch)
      end
    rescue Dalli::RingError => e
      # API cache uses MemCachier via Dalli. Dalli throws an error if it can't contact the store.
      logger.error "[ERROR]: Dalli::RingError - MemCachier isn't available? #{e}'"
      
      # The store isn't available, so get a fresh message:
      message = get_message
    rescue APICache::CannotFetch => e
      logger.error "[ERROR]: Request to Twitter failed AND the cache was expired or empty" 
      # Swallow the error and return nil
    rescue => e
      # Catch-all so that the site doesn't error when the Cache is broken
      # Should only get here if APICache threw an error - NOT if Twitter threw an error 
      # Log the error and try 
      logger.error "[ERROR]: #{e.class} - #{e.message}" 
      e.backtrace.each { |line| logger.error line }
      
      # Assume it's a problem with either the cache or APICache so get a fresh message:
      message = get_message
    end
    
    # This should only ever return nil if:
    # 1. The memcached store is unavailable
    # 2. api_cache threw an exception
    # 3. api_cache can't retrieve the tweet for over a day (very unlikely)

    return message
  end

  private
  
  def self.get_message(error_on_failure=nil)
    Twitter.user_timeline("swingoutlondon", count: 1).first
  rescue Exception => e  
    if e.message == "Bad Authentication data"
      # The app needs to have been registered with twitter and the following environment variables need to have been set: 
      #  - TWITTER_CONSUMER_KEY
      #  - TWITTER_CONSUMER_SECRET
      #  - TWITTER_OAUTH_TOKEN
      #  - TWITTER_OAUTH_TOKEN_SECRET
      logger.error "[ERROR]: Twitter couldn't authenticate the app. Have you registered the app and set all four environment variables (\"TWITTER_CONSUMER_KEY\" etc.)?"
    else
      logger.error "[ERROR]: #{e.class} - Failed to get latest tweet with message '#{e}'"
    end

    if error_on_failure
      raise error_on_failure # Tells APICache that it's failed, and to use the cached value
    end
  end
end
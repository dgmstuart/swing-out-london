class Tweet < ActiveRecord::Base    
  def self.message
    begin
      # Cache tweets for 30 minutes, timeout after 1 second
      message = APICache.get('latest_tweet', :cache => 1800, :timeout => 1) do
        logger.info "[INFO]: Retrieving Twitter message from twitter instead of the cache"
        begin
          get_message
        rescue Exception => e
           # The call to the twitter api fails if it can't reach twitter, so we need to handle this           
          logger.error "[ERROR]: #{e.class} - Failed to get latest tweet with message '#{e}'"
          raise APICache::InvalidResponse
        end
      end
    rescue Dalli::RingError => e
      # API cache uses MemCachier via Dalli. Dalli throws an error if it can't contact the store.
      logger.error "[ERROR]: Dalli::RingError - MemCachier isn't available? #{e}'"
      
      # The store isn't available, so get a fresh message:
      begin
        message = get_message
      rescue Exception => e  
        logger.error "[ERROR]: #{e.class} - Failed to get latest tweet with message '#{e}'"
        # swallow the error
      end
    rescue => e
      # Catch-all: so that the site doesn't crash when caching breaks
      logger.error "[ERROR]: #{e.class} - #{e.message}" 
      e.backtrace.each { |line| logger.error line }
      
      # Caching isn't working, so get a fresh message:
      begin
        message = get_message
      rescue Exception => e  
        logger.error "[ERROR]: #{e.class} - Failed to get latest tweet with message '#{e}'"
        # swallow the error
      end
    end
    
    # This should only ever nil if:
    # 1. The memcached store is unavailable
    # 2. api_cache threw an exception
    # 3. api_cache can't retrieve the tweet for over a day (very unlikely)
    
    return message
  end

  private
  
  def self.get_message
    Twitter.user_timeline("swingoutlondon").first
  end
end
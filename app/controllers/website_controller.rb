class WebsiteController < ApplicationController

  require 'rubygems'
  require 'twitter'
  
  def index
    @classes = Event.active_classes
    @socials_dates = Event.socials_dates(Date.today + (INITIAL_SOCIALS-1))  
    
    # The call to the twitter api fails if it can't reach twitter, so we need to handle this
    begin
      @latest_tweet = Twitter.user_timeline("swingoutlondon").first
    rescue Exception => msg
      @latest_tweet = nil
      logger.error "Failed to get latest tweet with message '#{msg}'"
    end
    
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @events }
    end
  end
  
  def about
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
  end
  
end

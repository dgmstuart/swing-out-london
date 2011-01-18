class WebsiteController < ApplicationController
  
  require 'rubygems'
  require 'twitter'
  
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
    
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @events }
    end
  end
  
  #TODO: move into a different file?
  def get_updated_times
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
    @last_updated_datetime = Event.last_updated_datetime
  end
  
end

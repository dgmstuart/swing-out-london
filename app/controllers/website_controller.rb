class WebsiteController < ApplicationController
  
  #require "twitter"
  
  def index
    @classes = Event.active_classes
    @socials_dates = Event.socials_dates(Date.today + (INITIAL_SOCIALS-1))  
    
    # @latest_tweet = Twitter.user_timeline("swingoutlondon").first.text
    @latest_tweet= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce tempus gravida dapibus. Curabitur eget eros arcu. Phasellus eget odio nullam."
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
end

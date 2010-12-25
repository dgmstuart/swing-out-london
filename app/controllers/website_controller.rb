class WebsiteController < ApplicationController
  def index
    @classes = Event.active_classes
    @socials_dates = Event.socials_dates(Date.today + (INITIAL_SOCIALS-1))  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
  def about
    @last_updated_time = Event.last_updated_datetime.to_s(:timepart)
    @last_updated_date = Event.last_updated_datetime.to_s(:listing_date)
  end
  
end

class WebsiteController < ApplicationController
  def index
    @classes = Event.classes
    @socials_dates = Event.socials_dates(Date.today + (INITIAL_SOCIALS-1))  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
end

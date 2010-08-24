class WebsiteController < ApplicationController
  def index
    @classes = Event.classes
    @socials_dates = Event.socials_dates(Date.today + 14)  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
end

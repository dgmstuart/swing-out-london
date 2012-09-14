class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # helper :all # include all helpers, all the time
  
  require 'digest/md5'
  
  def today
    if (Date.local_today.midnight)  > Time.local_now.ago(4.hours)
      # Would be great to just use 4.hours.ago, but timezones would screw it up??
      @today = Date.local_yesterday
    else
      @today = Date.local_today
    end
  end
end

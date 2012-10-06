class ApplicationController < ActionController::Base
  protect_from_forgery
  
  require 'digest/md5'
  
  def today
    if (Date.local_today.midnight)  > Time.local_now.ago(4.hours)
      # Would be great to just use 4.hours.ago, but timezones would screw it up??
      @today = Date.local_yesterday
    else
      @today = Date.local_today
    end
  end
  
  def sign_out
  
  end
  
  protected
  
  def authenticate
    session[:authenticated] =nil  
     authenticate_or_request_with_http_basic do |username, password|
      session[:authenticated] =( LOGINS[username] == Digest::MD5.hexdigest(password) )
    end
  end
  
  before_filter :get_controller_and_action
  
  def get_controller_and_action
    @controller_name = controller_name
    @action_name     = action_name 
  end
  
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'digest/md5'

  def today
    @today = if Date.local_today.midnight > Time.local_now.ago(4.hours)
               # Would be great to just use 4.hours.ago, but timezones would screw it up??
               Date.local_yesterday
             else
               Date.local_today
             end
  end

  def sign_out; end

  def not_found
    head :not_found, 'content_type' => 'text/plain'
  end

  protected

  before_action :set_controller_and_action_name

  def set_controller_and_action_name
    @controller_name = controller_name
    @action_name     = action_name
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def not_found
    head :not_found, 'content_type' => 'text/plain'
  end

  protected

  before_action :set_controller_and_action_name
  before_action :assign_last_updated_times

  def set_controller_and_action_name
    @controller_name = controller_name
    @action_name     = action_name
  end

  def assign_last_updated_times
    @last_updated_datetime = Event.last_updated_datetime
    @last_updated_time = @last_updated_datetime.to_s(:timepart)
    @last_updated_date = @last_updated_datetime.to_s(:listing_date)
  end

  private

  def today
    SOLDNTime.today
  end
end

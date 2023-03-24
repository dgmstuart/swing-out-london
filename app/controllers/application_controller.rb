# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def not_found
    head :not_found, 'content_type' => 'text/plain'
  end

  protected

  before_action :set_controller_and_action_name

  def set_controller_and_action_name
    @controller_name = controller_name
    @action_name     = action_name
  end

  private

  def today
    SOLDNTime.today
  end
end

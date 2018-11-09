# frozen_string_literal: true

class LoginSession
  def initialize(request)
    @request = request
  end

  def log_in!(auth_id)
    request.session[:auth_id] = auth_id
  end

  def log_out!
    request.reset_session
  end

  def logged_in?
    request.session[:auth_id].present?
  end

  private

  attr_reader :request
end

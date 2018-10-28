# frozen_string_literal: true

class LoginSession
  def initialize(request)
    @request = request
  end

  def log_in!
    request.session[:logged_in] = true
  end

  def log_out!
    request.reset_session
  end

  def logged_in?
    request.session[:logged_in] == true
  end

  private

  attr_reader :request
end

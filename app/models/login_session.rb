# frozen_string_literal: true

class LoginSession
  def initialize(session)
    @session = session
  end

  def log_in!
    session[:logged_in] = true
  end

  def logged_in?
    session[:logged_in] == true
  end

  private

  attr_reader :session
end

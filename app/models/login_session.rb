# frozen_string_literal: true

class LoginSession
  def initialize(request)
    @request = request
  end

  def log_in!(auth_id:, name:)
    request.session[:user] = { 'auth_id' => auth_id, 'name' => name }
  end

  def log_out!
    request.reset_session
  end

  def user
    if request.session[:user].present?
      User.new(request.session[:user])
    else
      Guest.new
    end
  end

  private

  attr_reader :request

  class User
    def initialize(user)
      @user = user
    end

    def logged_in?
      true
    end

    def name
      user.fetch('name')
    end

    private

    attr_reader :user
  end

  class Guest
    def logged_in?
      false
    end

    def name
      'Guest'
    end
  end
end

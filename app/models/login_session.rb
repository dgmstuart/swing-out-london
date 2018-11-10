# frozen_string_literal: true

class LoginSession
  def initialize(request, logger: Rails.logger)
    @request = request
    @logger = logger
  end

  def log_in!(auth_id:, name:, token:)
    request.session[:user] = { 'auth_id' => auth_id, 'name' => name, 'token' => token }
    logger.info("Logged in as auth id #{auth_id}")
  end

  def log_out!
    auth_id = user.auth_id
    request.reset_session
    logger.info("Logged out as auth id #{auth_id}")
  end

  def user
    if request.session[:user].present?
      User.new(request.session[:user])
    else
      Guest.new
    end
  end

  private

  attr_reader :request, :logger

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

    def auth_id
      user.fetch('auth_id')
    end

    def token
      user.fetch('token')
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

    def auth_id
      'NO ID'
    end

    def token
      'NO TOKEN'
    end
  end
end

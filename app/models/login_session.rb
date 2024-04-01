# frozen_string_literal: true

class LoginSession
  def initialize(request, role_finder: Role, logger: Rails.logger)
    @request = request
    @role_finder = role_finder
    @logger = logger
  end

  def log_in!(auth_id:, name:, token:, token_expires_at:)
    request.session[:user] = {
      "auth_id" => auth_id,
      "name" => name,
      "token" => token,
      "token_expires_at" => token_expires_at
    }
    log_message = "Logged in as auth id #{auth_id}"
    logger.info(log_message)
  end

  def set_token!(token:, token_expires_at:)
    request.session[:user]["token"] = token
    request.session[:user]["token_expires_at"] = token_expires_at
  end

  def log_out!
    auth_id = user.auth_id
    request.reset_session
    logger.info("Logged out as auth id #{auth_id}")
  end

  def user
    if request.session[:user].present?
      User.new(request.session[:user], role_finder:)
    else
      Guest.new
    end
  end

  private

  attr_reader :request, :role_finder, :logger

  class User
    def initialize(user, role_finder:)
      @user = user
      @role_finder = role_finder
    end

    def logged_in?
      role.present?
    end

    def name
      user.fetch("name")
    end

    def name_with_role
      if admin?
        "#{name} (Admin)"
      else
        name
      end
    end

    def admin?
      !!role&.admin?
    end

    def auth_id
      user.fetch("auth_id")
    end

    def token
      user.fetch("token")
    end

    def token_expires_at
      user.fetch("token_expires_at", 0)
    end

    private

    attr_reader :user, :role_finder

    def role
      role_finder.find_by(facebook_ref: auth_id)
    end
  end

  class Guest
    def logged_in?
      false
    end

    def name
      "Guest"
    end

    def name_with_role
      name
    end

    def admin?
      false
    end

    def auth_id
      "NO ID"
    end

    def token
      "NO TOKEN"
    end

    def token_expires_at
      0
    end
  end
end

# frozen_string_literal: true

class AuthResponse
  def initialize(request_env)
    @request_env = request_env
  end

  def email
    info.fetch("email")
  end

  def name
    info.fetch("name")
  end

  def token
    auth_hash.fetch("credentials").fetch("token")
  end

  private

  def info
    auth_hash.fetch("extra").fetch("raw_info")
  end

  def auth_hash
    request_env.fetch("omniauth.auth")
  end

  attr_reader :request_env
end

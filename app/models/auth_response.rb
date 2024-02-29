# frozen_string_literal: true

class AuthResponse
  def initialize(request_env)
    @auth_hash = request_env.fetch("omniauth.auth")
  end

  def id
    auth_hash.fetch("uid")
  end

  def name
    auth_hash.fetch("info").fetch("name")
  end

  def token
    credentials.fetch("token")
  end

  def expires_at
    credentials.fetch("expires_at")
  end

  private

  attr_reader :auth_hash

  def credentials
    auth_hash.fetch("credentials")
  end
end

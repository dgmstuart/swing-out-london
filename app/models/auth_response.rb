# frozen_string_literal: true

class AuthResponse
  def initialize(request_env)
    @request_env = request_env
  end

  def id
    auth_hash.fetch("uid")
  end

  def name
    auth_hash.fetch("info").fetch("name")
  end

  def team
    auth_hash.fetch("extra").fetch("raw_info").fetch("https://slack.com/team_id")
  end

  def token
    auth_hash.fetch("credentials").fetch("token")
  end

  private

  def auth_hash
    request_env.fetch("omniauth.auth")
  end

  attr_reader :request_env
end

# frozen_string_literal: true

class AuthResponse
  def initialize(request_env)
    @request_env = request_env
  end

  def id
    auth_hash.fetch('uid')
  end

  private

  def auth_hash
    request_env.fetch('omniauth.auth')
  end

  attr_reader :request_env
end

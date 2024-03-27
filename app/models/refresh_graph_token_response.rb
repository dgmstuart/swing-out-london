# frozen_string_literal: true

class RefreshGraphTokenResponse
  def initialize(response_body, now_in_seconds: Time.current.to_i)
    @data = JSON.parse(response_body)
    @now_in_seconds = now_in_seconds
  end

  def token
    data.fetch("access_token")
  end

  def token_expires_at
    now_in_seconds + data.fetch("expires_in")
  end

  private

  attr_reader :data, :now_in_seconds
end

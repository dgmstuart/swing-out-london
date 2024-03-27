# frozen_string_literal: true

class AccessTokenExpiry
  include ActionView::Helpers::TextHelper

  def initialize(user:, now_in_seconds: Time.current.to_i)
    @expiry_time = user.token_expires_at
    @now_in_seconds = now_in_seconds
  end

  def offset_string
    case status
    in :active
      "will expire in #{pluralize(days_offset, 'day')}"
    in :expired
      "has expired"
    end
  end

  def allow_refresh?
    days_offset < 59
  end

  private

  def days_offset
    ((expiry_time - now_in_seconds) / 86_400.0).ceil # 86400 = 1 day in seconds
  end

  def status
    if days_offset.positive?
      :active
    else
      :expired
    end
  end

  attr_reader :expiry_time, :now_in_seconds
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def not_found
    head :not_found, "content_type" => "text/plain"
  end

  before_action :http_authenticate

  protected

  before_action :set_controller_and_action_name
  before_action :assign_last_updated_times

  def set_controller_and_action_name
    @controller_name = controller_name
    @action_name     = action_name
  end

  def assign_last_updated_times
    @last_updated = LastUpdated.new
  end

  def http_authenticate
    credentials = ENV.values_at("BASIC_AUTH_USER", "BASIC_AUTH_PASSWORD")
    return if credentials.any?(&:blank?)

    authenticate_or_request_with_http_basic do |user, password|
      credentials == [user, password]
    end
  end

  def cache_action(cache_key, &)
    return yield unless cache_key

    cached = fetch_response("#{cache_key}-#{request.format}", &)

    render body: cached[:body], content_type: cached[:content_type] unless performed?
  end

  def fetch_response(key)
    Rails.cache.fetch(key, expires_in: 1.hour, race_condition_ttl: 10, skip_nil: true) do
      yield
      { body: response.body, content_type: response.media_type } if response.successful?
    end
  end
end

# frozen_string_literal: true

require "facebook_graph_api/api"

# Uses the Facebook Graph API to fetch the name of a user, based on their
# App-Scoped User ID
class UserName
  def initialize(
    api:,
    error_reporter: Rollbar,
    cache: Rails.cache
  )
    @api = api
    @error_reporter = error_reporter
    @cache = cache
  end

  class << self
    def as_user(user)
      api = FacebookGraphApi::Api.for_token(user.token)
      new(api:)
    end
  end

  def name_for(user_id)
    cache.fetch("fb-user-name-#{user_id}", expires_in: 1.month) do
      profile = api.profile(user_id)
      profile.fetch("name")
    end
  rescue FacebookGraphApi::HttpClient::ResponseError => e
    error_reporter.error(e)
    "[Unknown user]"
  end

  private

  attr_reader :api, :error_reporter, :cache
end

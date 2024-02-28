# frozen_string_literal: true

require "facebook_graph_api/user_api"

class UserName
  def initialize(
    api:,
    error_reporter: Rollbar
  )
    @api = api
    @error_reporter = error_reporter
  end

  class << self
    def as_user(user)
      api = FacebookGraphApi::UserApi.for_user(user)
      new(api:)
    end
  end

  def name_for(user_id)
    profile = api.profile(user_id)
    profile.fetch("name")
  rescue FacebookGraphApi::HttpClient::ResponseError => e
    error_reporter.error(e)
    "[Unknown user]"
  end

  private

  attr_reader :api, :error_reporter
end

# frozen_string_literal: true

class UserName
  def initialize(
    user:,
    api_builder: FacebookGraphApi::UserApi,
    error_reporter: Rollbar
  )
    @user = user
    @api_builder = api_builder
    @error_reporter = error_reporter
  end

  def name_for(user_id)
    api = api_builder.for_user(user)
    profile = api.profile(user_id)
    profile.fetch("name")
  rescue FacebookGraphApi::HttpClient::ResponseError => e
    error_reporter.error(e)
    "[Unknown user]"
  end

  private

  attr_reader :user, :api_builder, :error_reporter
end

# frozen_string_literal: true

if Rails.env.development? && ENV.fetch("SKIP_LOGIN", "false") == "true"
  require "omniauth_test_response_builder"
  OmniAuth.config.test_mode = true

  # Our locale files haven't been loaded yet so we need to do it ourselves here:
  I18n.load_path += Dir[Rails.root.join("config/locales/*.{rb,yml}").to_s]

  OmniauthTestResponseBuilder.new.stub_auth_hash
else
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :openid_connect, {
      name: :slack,
      # issuer needs to be explicitly specified because slack doesn't expose /.well-known/webfinger
      issuer: "https://slack.com",
      scope: %i[openid profile],
      discovery: true,
      extra_authorize_params: {
        team: ENV.fetch("SLACK_TEAM_ID")
      },
      client_options: {
        host: "slack.com",
        identifier: ENV.fetch("SLACK_LOGIN_CLIENT_ID"),
        secret: ENV.fetch("SLACK_LOGIN_CLIENT_SECRET"),
        redirect_uri: URI.join(ENV.fetch("HOST"), "/auth/slack/callback")
      }
    }
  end
end

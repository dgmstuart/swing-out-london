# frozen_string_literal: true

if Rails.env.development? && ENV.fetch("SKIP_LOGIN", "false") == "true"
  require "omniauth_test_response_builder"
  require "faker/auth0"
  OmniAuth.config.test_mode = true
  login_user_email = ENV.fetch("DEVELOPMENT_USER_LOGIN_EMAIL", Faker::Internet.email)

  # Our locale files haven't been loaded yet so we need to do it ourselves here:
  I18n.load_path += Dir[Rails.root.join("config/locales/*.{rb,yml}").to_s]

  OmniauthTestResponseBuilder.new.stub_auth_hash(email: login_user_email)
else
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :auth0,
      ENV.fetch("AUTH0_CLIENT_ID", nil),
      ENV.fetch("AUTH0_CLIENT_SECRET", nil),
      ENV.fetch("AUTH0_DOMAIN", nil),
      callback_path: "/auth/callback",
      authorize_params: {
        scope: "openid profile email"
      }
    )
  end
end

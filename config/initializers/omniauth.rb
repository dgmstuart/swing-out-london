# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"], scope: ""
end

if Rails.env.development?
  require "omniauth_test_response_builder"
  require "faker/facebook"
  OmniAuth.config.test_mode = true
  login_user_id = ENV.fetch("DEVELOPMENT_USER_LOGIN_ID", Faker::Facebook.uid)

  # Our locale files haven't been loaded yet so we need to do it ourselves here:
  I18n.load_path += Dir[Rails.root.join("config/locales/*.{rb,yml}").to_s]

  OmniauthTestResponseBuilder.new.stub_auth_hash(id: login_user_id)
end

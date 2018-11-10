# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], scope: ''
end

if Rails.env.development?
  require 'omniauth_test_response_builder'
  OmniAuth.config.test_mode = true
  login_user_id = ENV.fetch('DEVELOPMENT_USER_LOGIN_ID', Faker::Number.number(17))
  OmniauthTestResponseBuilder.new.stub_auth_hash(id: login_user_id)
end

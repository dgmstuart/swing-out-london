# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_id = ENV.fetch("FACEBOOK_APP_ID", nil)
  config.x.facebook.app_secret = ENV.fetch("FACEBOOK_SECRET", nil)
  config.x.facebook.api_base = "https://graph.facebook.com/"
  config.x.facebook.test_user_app_id = ENV.fetch("FACEBOOK_TEST_USER_APP_ID", nil)
end

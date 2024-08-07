# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_id = ENV.fetch("FACEBOOK_APP_ID", nil)
  config.x.facebook.app_secret = ENV.fetch("FACEBOOK_SECRET", nil)
  config.x.facebook.api_base = "https://graph.facebook.com/"
end

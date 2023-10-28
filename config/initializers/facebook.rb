# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_secret = ENV.fetch("FACEBOOK_SECRET", nil)
  config.x.facebook.api_base = "https://graph.facebook.com/"
  config.x.facebook.editor_user_ids = ENV.fetch("EDITOR_USER_IDS", "").split(",")
end

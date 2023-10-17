# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_id = ENV.fetch("FACEBOOK_APP_ID", nil)
end

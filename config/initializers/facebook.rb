# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_id = ENV['FACEBOOK_APP_ID']
  config.x.facebook.url = 'https://www.facebook.com/swingoutlondon'
end

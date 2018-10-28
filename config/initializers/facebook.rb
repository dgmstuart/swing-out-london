# frozen_string_literal: true

Rails.application.configure do
  config.x.facebook.app_id = ENV['FACEBOOK_APP_ID']
  config.x.facebook.url = 'https://www.facebook.com/swingoutlondon'
  config.x.facebook.api_base = 'https://graph.facebook.com/'
  config.x.facebook.admin_user_ids = ENV.fetch('ADMIN_USER_IDS', '').split(',')
end

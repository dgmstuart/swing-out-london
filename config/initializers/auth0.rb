# frozen_string_literal: true

Rails.application.configure do
  config.x.auth0.client_id = ENV.fetch("AUTH0_CLIENT_ID", nil)
  config.x.auth0.client_secret = ENV.fetch("AUTH0_CLIENT_SECRET", nil)
  config.x.auth0.domain = ENV.fetch("AUTH0_DOMAIN", nil)
end

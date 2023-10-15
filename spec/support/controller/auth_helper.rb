# frozen_string_literal: true

require "faker/auth0"

module Controller
  module AuthHelper
    def login(
      auth_id: Faker::Auth0.uid,
      name: Faker::Name.lindy_hop_name,
      token: Faker::Auth0.access_token
    )
      LoginSession.new(controller.request).log_in!(auth_id:, name:, token:)
    end
  end
end

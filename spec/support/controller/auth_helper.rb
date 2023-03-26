# frozen_string_literal: true

require "faker/facebook"

module Controller
  module AuthHelper
    def login(
      auth_id: Faker::Facebook.uid,
      name: Faker::Name.lindy_hop_name,
      token: Faker::Facebook.access_token
    )
      LoginSession.new(controller.request).log_in!(auth_id:, name:, token:)
    end
  end
end

# frozen_string_literal: true

require "faker/slack"

module Controller
  module AuthHelper
    def login(
      auth_id: Faker::Slack.uid,
      name: Faker::Name.lindy_hop_name,
      token: Faker::Slack.access_token
    )
      LoginSession.new(controller.request).log_in!(auth_id:, name:, token:)
    end
  end
end

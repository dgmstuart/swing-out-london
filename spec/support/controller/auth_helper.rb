# frozen_string_literal: true

module Controller
  module AuthHelper
    def login(
      auth_id: Faker::Number.number(17),
      name: Faker::Name.lindy_hop_name,
      token: SecureRandom.hex
    )
      LoginSession.new(controller.request).log_in!(auth_id: auth_id, name: name, token: token)
    end
  end
end

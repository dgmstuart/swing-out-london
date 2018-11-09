# frozen_string_literal: true

module Controller
  module AuthHelper
    def login(auth_id: 12345678901234567)
      LoginSession.new(controller.request).log_in!(auth_id)
    end
  end
end

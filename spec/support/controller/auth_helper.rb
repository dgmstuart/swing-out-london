# frozen_string_literal: true

module Controller
  module AuthHelper
    def login
      LoginSession.new(controller.request).log_in!
    end
  end
end

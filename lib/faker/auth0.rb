# frozen_string_literal: true

module Faker
  class Auth0
    class << self
      def uid
        "google-oauth1|#{Faker::Number.number(digits: 21)}"
      end

      def access_token
        SecureRandom.hex
      end

      def id_token
        SecureRandom.hex
      end
    end
  end
end

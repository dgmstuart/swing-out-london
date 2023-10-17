# frozen_string_literal: true

module Faker
  class Slack
    class << self
      def uid
        SecureRandom.hex(4).upcase
      end

      def access_token
        SecureRandom.hex
      end
    end
  end
end

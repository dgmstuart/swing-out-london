# frozen_string_literal: true

module Faker
  class Facebook
    class << self
      def uid
        Number.number(digits: 17)
      end
    end
  end
end

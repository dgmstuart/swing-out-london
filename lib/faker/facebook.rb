# frozen_string_literal: true

module Faker
  # {https://github.com/faker-ruby/faker Faker} extension for values specific to the Facebook Graph API.
  class Facebook
    class << self
      def uid
        Number.number(digits: 17)
      end
    end
  end
end

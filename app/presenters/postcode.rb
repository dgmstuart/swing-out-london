# frozen_string_literal: true

class Postcode
  class << self
    def build(postcode_string)
      if postcode_string.present?
        new(postcode_string)
      else
        SecretPostcode.new
      end
    end
  end

  def initialize(postcode_string)
    @postcode_string = postcode_string
  end

  def short
    # Match the first part of the postcode:
    regexp = /^([A-Z0-9]{2,4})(?:\s*[A-Z0-9]{3})?$/

    matches = regexp.match(postcode_string.strip.upcase)

    raise ArgumentError, "Couldn't parse #{postcode_string} as a postcode" unless matches

    matches[1]
  end

  def description
    "#{postcode_string} to be precise. Click to see the venue on a map"
  end

  private

  attr_reader :postcode_string
end

class SecretPostcode
  def short
    "???"
  end

  def description
    "Bah - this event is too secret to have a postcode!"
  end
end

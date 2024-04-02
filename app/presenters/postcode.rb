# frozen_string_literal: true

# Presenter exposing different ways to format a Postcode
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
    # Match the first part of the postcode - the "outward code":
    regexp = /^(?<outward_code>[A-Z0-9]{2,4})(?:\s*[A-Z0-9]{3})?$/

    matches = postcode_string.strip.upcase.match(regexp)

    raise(ArgumentError, "Couldn't parse #{postcode_string} as a postcode") if matches.nil?

    matches[:outward_code]
  end

  def description
    "#{postcode_string} to be precise. Click to see the venue on a map"
  end

  private

  attr_reader :postcode_string
end

# Handles events which don't publicise their address
class SecretPostcode
  def short
    "???"
  end

  def description
    "Bah - this event is too secret to have a postcode!"
  end
end

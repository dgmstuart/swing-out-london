# frozen_string_literal: true

require "active_support/testing/time_helpers"

# Wrapper around ActiveSupport::Testing::TimeHelpers that guarantees
# travel_back runs after each example.
# rails_helper specs get this for free via rspec-rails, but spec_helper specs need it.
module TimeHelpers
  def self.included(base)
    base.include ActiveSupport::Testing::TimeHelpers
    base.after { travel_back } # rubocop:disable Rails/RedundantTravelBack
  end
end

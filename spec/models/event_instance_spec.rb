# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"

RSpec.describe EventInstance do
  describe "(associations)" do
    it { is_expected.to belong_to(:event) }
  end
end

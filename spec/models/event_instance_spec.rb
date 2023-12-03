# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"

RSpec.describe EventInstance do
  describe "(associations)" do
    it { is_expected.to belong_to(:event) }
  end

  describe "(validations)" do
    it "ensures that the combination of date and event_id is unique" do
      instance = build(:event_instance)
      expect(instance).to validate_uniqueness_of(:date)
        .scoped_to(:event_id)
        .with_message(/The date '.*' has already been taken/)
    end
  end
end

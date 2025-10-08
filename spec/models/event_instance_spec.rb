# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"
require "app/validators/distant_past_date_validator"

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

    it "allows past dates" do
      instance = build(:event_instance, date: Date.parse("2010-12-01"))
      instance.valid?
      expect(instance.errors.messages).to be_empty
    end

    it "disallows distant past dates" do
      instance = build(:event_instance, date: Date.parse("2009-12-01"))
      instance.valid?
      expect(instance.errors.messages).to eq(date: ["can't be too far in the past"])
    end
  end
end

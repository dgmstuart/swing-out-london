# frozen_string_literal: true

require "rails_helper"
require "support/shoulda_matchers"

RSpec.describe EventHiatus do
  describe "Associations" do
    it { is_expected.to belong_to(:event) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:return_date) }

    it "doesn't double-report errors when start date is nil" do
      hiatus = build(:event_hiatus, start_date: nil, return_date: "2012-01-19")
      hiatus.valid?
      expect(hiatus.errors.messages[:return_date]).to be_empty
    end

    context "when start date has a value" do
      subject { build(:event_hiatus, start_date: "2012-01-12") }

      it { is_expected.to validate_comparison_of(:return_date).is_greater_than(:start_date) }
    end

    it "allows past dates" do
      hiatus = build(:event_hiatus, start_date: "2010-12-01", return_date: "2010-12-08")
      hiatus.valid?
      expect(hiatus.errors.messages).to be_empty
    end

    it "disallows distant past dates" do
      hiatus = build(:event_hiatus, start_date: "2009-12-01", return_date: "2009-12-08")
      hiatus.valid?
      expect(hiatus.errors.messages).to eq(
        start_date: ["can't be too far in the past"],
        return_date: ["can't be too far in the past"]
      )
    end
  end
end

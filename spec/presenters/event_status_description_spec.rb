# frozen_string_literal: true

require "spec_helper"
require "support/time_formats_helper"
require "app/presenters/event_status_description"
require "active_support"

RSpec.describe EventStatusDescription do
  describe "#description" do
    context "when the event is not listed" do
      it "is 'Not listed'" do
        event = instance_double("Event")
        status_calculator = instance_double("EventStatus", status_for: :not_listed)
        status = described_class.new(event, status_calculator:)

        expect(status.description).to eq "Not listed (no future dates)"
      end
    end

    context "when the event is listed" do
      it "is 'Listed'" do
        event = instance_double("Event", latest_date: Date.parse("2024-04-07"))
        status_calculator = instance_double("EventStatus", status_for: :listed)
        status = described_class.new(event, status_calculator:)

        expect(status.description).to eq "Will be listed until 07/04/2024"
      end
    end
  end

  describe "#css_class" do
    context "when the event is not listed" do
      it "is 'alert'" do
        status_calculator = instance_double("EventStatus", status_for: :not_listed)
        status = described_class.new(double, status_calculator:)

        expect(status.css_class).to eq "alert"
      end
    end

    context "when the event is listed" do
      it "is 'notice'" do
        status_calculator = instance_double("EventStatus", status_for: :listed)
        status = described_class.new(double, status_calculator:)

        expect(status.css_class).to eq "notice"
      end
    end
  end
end

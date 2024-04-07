# frozen_string_literal: true

require "spec_helper"
require "app/services/event_archiver"
require "active_support"
require "active_support/testing/time_helpers"
require "active_support/core_ext/date_and_time/calculations" # for prev_occurring

RSpec.describe EventArchiver do
  include ActiveSupport::Testing::TimeHelpers

  describe "#archive" do
    context "when the event has already ended" do
      it "does not update the event" do
        event = instance_double("Event", ended?: true, update: true)

        described_class.new.archive(event)

        expect(event).not_to have_received(:update)
      end

      it "returns true" do
        event = instance_double("Event", ended?: true)

        expect(described_class.new.archive(event)).to be true
      end
    end

    context "when the event is weekly" do
      it "sets the last date to the most recent occurrence (based on weekday)" do
        travel_to(Date.parse("2024-04-07"))
        event = instance_double("Event", ended?: false, weekly?: true, day: "Wednesday", update: true)

        described_class.new.archive(event)

        expect(event).to have_received(:update).with(last_date: Date.parse("2024-04-03"))
      end

      it "returns whether the event was updated or not" do
        result = double
        event = instance_double("Event", ended?: false, weekly?: true, day: "Wednesday", update: result)

        expect(described_class.new.archive(event)).to eq result
      end
    end

    context "when the event is occasional" do
      it "sets the last date to the most recent occurrence (based on weekday)" do
        latest_date = instance_double("Date")
        event = instance_double("Event", ended?: false, weekly?: false, latest_date:, update: true)

        described_class.new.archive(event)

        expect(event).to have_received(:update).with(last_date: latest_date)
      end

      it "returns whether the event was updated or not" do
        result = double
        event = instance_double("Event", ended?: false, weekly?: false, latest_date: double, update: result)

        expect(described_class.new.archive(event)).to eq result
      end
    end

    context "when the event is occasional, but the latest date couldn't be identified" do
      it "sets the last date to THE BEGINNING OF TIME" do
        event = instance_double("Event", ended?: false, weekly?: false, latest_date: nil, update: true)

        described_class.new.archive(event)

        expect(event).to have_received(:update).with(last_date: Date.new)
      end

      it "returns whether the event was updated or not" do
        result = double
        event = instance_double("Event", ended?: false, weekly?: false, latest_date: nil, update: result)

        expect(described_class.new.archive(event)).to eq result
      end
    end
  end
end

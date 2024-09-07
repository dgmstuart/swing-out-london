# frozen_string_literal: true

require "spec_helper"
require "app/models/event_status"
require "active_support"
require "active_support/testing/time_helpers"

RSpec.describe EventStatus do
  include ActiveSupport::Testing::TimeHelpers

  describe "#status_for" do
    context "when there are dates in the past" do
      it "is 'Not listed'" do
        event = instance_double("Event", future_dates?: false, latest_date: double)

        status = described_class.new.status_for(event)

        expect(status).to eq :not_listed
      end
    end

    context "when the latest date is today" do
      it "is 'Listed'" do
        today = Date.parse("2024-04-07")
        travel_to(today)
        event = instance_double("Event", future_dates?: false, latest_date: today)

        status = described_class.new.status_for(event)

        expect(status).to eq :listed
      end
    end

    context "when there are dates in the future" do
      it "is 'Will be listed until' the latest date" do
        latest_date = Date.parse("2024-04-07")
        event = instance_double("Event", future_dates?: true, latest_date:)

        status = described_class.new.status_for(event)

        expect(status).to eq :listed
      end
    end
  end
end

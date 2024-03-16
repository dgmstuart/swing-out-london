# frozen_string_literal: true

require "rails_helper"

RSpec.describe Audit do
  describe "#editor_name" do
    it "is the name of the person who made the change" do
      audit = build(:audit, username: { "name" => "Alice" })

      expect(audit.editor_name).to eq "Alice"
    end
  end

  describe "#auditable" do
    context "when the record is an Event" do
      it "returns the specified event" do
        event = create(:event)
        audit = create(:audit, auditable_type: "Event", auditable_id: event.id)

        expect(audit.auditable).to eq event
      end
    end

    context "when the record is an Organiser" do
      it "returns the specified event" do
        organiser = create(:organiser)
        audit = create(:audit, auditable_type: "Organiser", auditable_id: organiser.id)

        expect(audit.auditable).to eq organiser
      end
    end

    context "when the record is a Venue" do
      it "returns the specified event" do
        venue = create(:venue)
        audit = create(:audit, auditable_type: "Venue", auditable_id: venue.id)

        expect(audit.auditable).to eq venue
      end
    end
  end
end

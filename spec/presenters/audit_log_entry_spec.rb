# frozen_string_literal: true

require "spec_helper"
require "app/presenters/audit_log_entry"

RSpec.describe AuditLogEntry do
  describe "#created_at" do
    it "delegates to the audit" do
      created_at = DateTime.new
      audit = instance_double("Audit", created_at:)

      expect(described_class.new(audit).created_at).to eq created_at
    end
  end

  describe "#username" do
    it "delegates to the audit" do
      audit = instance_double("Audit", username: "Bob")

      expect(described_class.new(audit).username).to eq "Bob"
    end
  end

  describe "#action" do
    it "delegates to the audit" do
      audit = instance_double("Audit", action: "create")

      expect(described_class.new(audit).action).to eq "create"
    end
  end

  describe "#auditable_type" do
    it "delegates to the audit" do
      audit = instance_double("Audit", auditable_type: "Event")

      expect(described_class.new(audit).auditable_type).to eq "Event"
    end
  end

  describe "#auditable_id" do
    it "delegates to the audit" do
      audit = instance_double("Audit", auditable_id: 23)

      expect(described_class.new(audit).auditable_id).to eq 23
    end
  end

  describe "#auditable_name" do
    context "when the auditable record is a dance class" do
      it "is Class" do
        auditable = instance_double("Event", has_class?: true, has_social?: false)
        audit = instance_double("Audit", auditable:, auditable_type: "Event")

        expect(described_class.new(audit).auditable_name).to eq "Class"
      end
    end

    context "when the auditable record has a social dance" do
      it "is the name of that event" do
        auditable = instance_double("Event", has_class?: true, has_social?: true, title: "Stomp")
        audit = instance_double("Audit", auditable:, auditable_type: "Event")

        expect(described_class.new(audit).auditable_name).to eq 'Event: "Stomp"'
      end

      it "shows an empty name if the event has been deleted" do
        audit = instance_double("Audit", auditable: nil, auditable_type: "Event")

        expect(described_class.new(audit).auditable_name).to eq 'Event: ""'
      end
    end

    context "when the auditable record is a venue" do
      it "is the name of the venue" do
        auditable = instance_double("Venue", name: "The Bar")
        audit = instance_double("Audit", auditable:, auditable_type: "Venue")

        expect(described_class.new(audit).auditable_name).to eq 'Venue: "The Bar"'
      end

      it "shows an empty name if the venue has been deleted" do
        audit = instance_double("Audit", auditable: nil, auditable_type: "Venue")

        expect(described_class.new(audit).auditable_name).to eq 'Venue: ""'
      end
    end

    context "when the auditable record is an organiser" do
      it "is the name of the organiser" do
        auditable = instance_double("Organiser", name: "Bob")
        audit = instance_double("Audit", auditable:, auditable_type: "Organiser")

        expect(described_class.new(audit).auditable_name).to eq 'Organiser: "Bob"'
      end

      it "shows an empty name if the organiser has been deleted" do
        audit = instance_double("Audit", auditable: nil, auditable_type: "Organiser")

        expect(described_class.new(audit).auditable_name).to eq 'Organiser: ""'
      end
    end
  end

  describe "#audited_changes" do
    it "delegates to the audit" do
      audit = instance_double("Audit", audited_changes: "something changed")

      expect(described_class.new(audit).audited_changes).to eq "something changed"
    end
  end

  describe "#comment" do
    it "delegates to the audit" do
      audit = instance_double("Audit", comment: "something changed")

      expect(described_class.new(audit).comment).to eq "something changed"
    end
  end

  describe "#as_json" do
    it "presents the key fields as a hash" do # rubocop:disable RSpec/ExampleLength
      audited_changes = double
      audit = instance_double(
        "Audit",
        editor_name: "Bob",
        created_at: Time.parse("Sat, 16 Mar 2024 18:53:53 GMT +00:00"),
        action: "create",
        auditable_type: "Event",
        auditable_id: 17,
        audited_changes:,
        comment: "more changes"
      )
      time_formatter = ->(time) { time.strftime("%Y-%m-%d %H:%M:%S") }

      expect(described_class.new(audit, time_formatter:).as_json).to eq(
        action: "create",
        changes: audited_changes,
        comment: "more changes",
        created_at: "2024-03-16 18:53:53",
        edited_by: "Bob",
        record: "Event(17)"
      )
    end
  end
end

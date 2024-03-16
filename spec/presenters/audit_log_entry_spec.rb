# frozen_string_literal: true

require "spec_helper"
require "app/presenters/audit_log_entry"

RSpec.describe AuditLogEntry do
  describe "#created_at" do
    it "delegates to the audit" do
      created_at = DateTime.new
      audit = instance_double("Audit", created_at:)

      expect(described_class.new(audit, url_helpers:).created_at).to eq created_at
    end
  end

  describe "#username" do
    it "delegates to the audit" do
      audit = instance_double("Audit", username: "Bob")

      expect(described_class.new(audit, url_helpers:).username).to eq "Bob"
    end
  end

  describe "#action" do
    it "delegates to the audit" do
      audit = instance_double("Audit", action: "create")

      expect(described_class.new(audit, url_helpers:).action).to eq "create"
    end

    it "is 'delete' if the action was 'destroy'" do
      audit = instance_double("Audit", action: "destroy")

      expect(described_class.new(audit, url_helpers:).action).to eq "delete"
    end
  end

  describe "#auditable_id" do
    it "delegates to the audit" do
      audit = instance_double("Audit", auditable_id: 23)

      expect(described_class.new(audit, url_helpers:).auditable_id).to eq 23
    end
  end

  describe "#auditable_name" do
    context "when the auditable record is a dance class" do
      it "is Class" do
        auditable = instance_double("Event", has_class?: true, has_social?: false)
        audit = instance_double("Audit", action: "update", auditable:, auditable_type: "Event")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq "Class"
      end
    end

    context "when the auditable record has a social dance" do
      it "is the name of that event" do
        auditable = instance_double("Event", has_class?: true, has_social?: true, title: "Stomp")
        audit = instance_double("Audit", action: "update", auditable:, auditable_type: "Event")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq 'Event: "Stomp"'
      end

      it "shows deleted if the event has been deleted" do
        audit = instance_double("Audit", action: "update", auditable: nil, auditable_type: "Event")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq "Event [DELETED]"
      end
    end

    context "when the auditable record is a venue" do
      it "is the name of the venue" do
        auditable = instance_double("Venue", name: "The Bar")
        audit = instance_double("Audit", action: "update", auditable:, auditable_type: "Venue")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq 'Venue: "The Bar"'
      end

      it "shows deleted if the venue has been deleted" do
        audit = instance_double("Audit", action: "update", auditable: nil, auditable_type: "Venue")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq "Venue [DELETED]"
      end
    end

    context "when the auditable record is an organiser" do
      it "is the name of the organiser" do
        auditable = instance_double("Organiser", name: "Bob")
        audit = instance_double("Audit", action: "update", auditable:, auditable_type: "Organiser")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq 'Organiser: "Bob"'
      end

      it "shows deleted if the organiser has been deleted" do
        audit = instance_double("Audit", action: "update", auditable: nil, auditable_type: "Organiser")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq "Organiser [DELETED]"
      end
    end

    context "when the audit is for the action which deleted the record" do
      it "is just the record type" do
        audit = instance_double("Audit", action: "destroy", auditable: nil, auditable_type: "Organiser")

        expect(described_class.new(audit, url_helpers:).auditable_name).to eq "Organiser"
      end
    end
  end

  describe "#audited_changes" do
    it "delegates to the audit" do
      audit = instance_double("Audit", audited_changes: "something changed")

      expect(described_class.new(audit, url_helpers:).audited_changes).to eq "something changed"
    end
  end

  describe "#comment" do
    it "delegates to the audit" do
      audit = instance_double("Audit", comment: "something changed")

      expect(described_class.new(audit, url_helpers:).comment).to eq "something changed"
    end
  end

  describe "#record_url" do
    context "when the auditable record is an event" do
      it "is the url of that event" do
        audit = instance_double("Audit", auditable_type: "Event", auditable_id: "23")
        url_helpers = instance_double("UrlHelpers", event_url: "a/url")

        expect(described_class.new(audit, url_helpers:).auditable_url).to eq "a/url"
      end
    end

    context "when the auditable record is a venue" do
      it "is the url of that venue" do
        audit = instance_double("Audit", auditable_type: "Venue", auditable_id: "23")
        url_helpers = instance_double("UrlHelpers", venue_url: "a/url")

        expect(described_class.new(audit, url_helpers:).auditable_url).to eq "a/url"
      end
    end

    context "when the auditable record is an organiser" do
      it "is the url of that organiser" do
        audit = instance_double("Audit", auditable_type: "Organiser", auditable_id: "23")
        url_helpers = instance_double("UrlHelpers", organiser_url: "a/url")

        expect(described_class.new(audit, url_helpers:).auditable_url).to eq "a/url"
      end
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

      expect(described_class.new(audit, time_formatter:, url_helpers:).as_json).to eq(
        action: "create",
        changes: audited_changes,
        comment: "more changes",
        created_at: "2024-03-16 18:53:53",
        edited_by: "Bob",
        record: "Event(17)"
      )
    end
  end

  def url_helpers
    double
  end
end

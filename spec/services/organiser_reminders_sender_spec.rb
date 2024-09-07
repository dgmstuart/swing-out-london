# frozen_string_literal: true

require "spec_helper"
require "app/services/organiser_reminders_sender"

RSpec.describe OrganiserRemindersSender do
  describe "send_unlisted" do
    context "when there are no events with organiser emails" do
      it "doesn't send any email" do
        email_sender = instance_double("OrganiserReminderSender", send!: double)
        event_finder = class_double("Event", notifiable: [])
        event_status_calculator = double
        sender = described_class.new(email_sender:, event_finder:, event_status_calculator:)

        sender.send_unlisted

        expect(email_sender).not_to have_received(:send!)
      end
    end

    context "when there is an unlisted event with an organiser email" do
      it "sends an email" do
        email_sender = instance_double("OrganiserReminderSender", send!: double)
        event = instance_double("Event")
        event_finder = class_double("Event", notifiable: [event])
        event_status_calculator = instance_double("EventStatus", status_for: :not_listed)
        sender = described_class.new(email_sender:, event_finder:, event_status_calculator:)

        sender.send_unlisted

        expect(email_sender).to have_received(:send!).with(event)
      end
    end

    context "when all events with an organiser email are listed" do
      it "doesn't send any email" do
        email_sender = instance_double("OrganiserReminderSender", send!: double)
        event = instance_double("Event")
        event_finder = class_double("Event", notifiable: [event])
        event_status_calculator = instance_double("EventStatus", status_for: :listed)
        sender = described_class.new(email_sender:, event_finder:, event_status_calculator:)

        sender.send_unlisted

        expect(email_sender).not_to have_received(:send!).with(event)
      end
    end
  end
end

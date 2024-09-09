# frozen_string_literal: true

require "spec_helper"
require "app/services/organiser_reminder_sender"
require "active_support"
require "active_support/core_ext/numeric/time"

RSpec.describe OrganiserReminderSender do
  describe "send!" do
    it "enqueues an email to be sent" do
      mail = fake_mail
      mailer = fake_mailer(mail)
      event = instance_double("Event", reminder_email_address: "herbert@white.com", last_reminder_delivered_at: nil)
      sender = described_class.new(mailer:)

      sender.send!(event)

      aggregate_failures do
        expect(mailer).to have_received(:reminder_email).with(to: "herbert@white.com", event:)
        expect(mail).to have_received(:deliver_later)
      end
    end

    context "when an email has recently been sent" do
      it "does nothing" do
        mail = fake_mail
        mailer = fake_mailer(mail)
        event = instance_double("Event", reminder_email_address: "herbert@white.com", last_reminder_delivered_at: 1.day.ago)
        sender = described_class.new(mailer:)

        sender.send!(event)

        expect(mail).not_to have_received(:deliver_later)
      end
    end

    context "when an email was sent more than a week ago" do
      it "enqueues an email to be sent" do
        mail = fake_mail
        mailer = fake_mailer(mail)
        event = instance_double("Event", reminder_email_address: "herbert@white.com", last_reminder_delivered_at: 8.days.ago)
        sender = described_class.new(mailer:)

        sender.send!(event)

        expect(mail).to have_received(:deliver_later)
      end
    end

    def fake_mailer(mail = fake_mail)
      class_double("OrganiserMailer", reminder_email: mail)
    end

    def fake_mail
      instance_double("ActionMailer::MessageDelivery", deliver_later: double)
    end
  end
end

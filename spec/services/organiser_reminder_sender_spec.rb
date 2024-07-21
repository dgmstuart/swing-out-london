# frozen_string_literal: true

require "spec_helper"
require "app/services/organiser_reminder_sender"

RSpec.describe OrganiserReminderSender do
  describe "send!" do
    it "enqueues an email to be sent" do
      mail = instance_double("ActionMailer::MessageDelivery", deliver_later: double)
      mailer = class_double("OrganiserMailer", reminder_email: mail)
      event = instance_double("Event", reminder_email_address: "herbert@white.com")
      sender = described_class.new(mailer:)

      sender.send!(event)

      aggregate_failures do
        expect(mailer).to have_received(:reminder_email).with(to: "herbert@white.com", event:)
        expect(mail).to have_received(:deliver_later)
      end
    end
  end
end

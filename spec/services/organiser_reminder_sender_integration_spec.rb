# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrganiserReminderSender do
  include ActionMailer::TestHelper # assert_emails is defined in ActionMailer::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  describe "INTEGRATION TEST" do
    around do |example|
      ClimateControl.modify CANONICAL_HOST: "example.com" do
        example.run
      end
    end

    it "sends a reminder email about the event" do
      organiser_token = "41b783b5e27fb2eddd5456a182db56c4"
      event = create(
        :event,
        :occasional,
        title: "The Hot One",
        organiser_token:,
        reminder_email_address: "herbert@white.com"
      )
      sender = described_class.new

      assert_emails 1 do
        sender.send!(event)
      end

      email = ActionMailer::Base.deliveries.sole
      aggregate_failures do
        expect(email.to).to eq ["herbert@white.com"]
        expect(email.from).to eq ["swingoutlondon@gmail.com"]
        expect(email.subject).to eq 'Swing Out London is missing dates for "The Hot One"'

        text_part, html_part = email.parts.map { |part| part.body.to_s }

        html_body = Capybara.string(html_part)
        expect(html_body).to have_content "We don't seem to have any future dates for your event: \"The Hot One\""
        expect(html_body).to have_content "You can add new dates using this link:"
        expect(html_body).to have_link "https://example.com/external_events/41b783b5e27fb2eddd5456a182db56c4/edit"

        expect(text_part).to include "We don't seem to have any future dates for your event: \"The Hot One\""
        expect(text_part).to include "You can add new dates using this link:"

        expect(EmailDelivery.sole.recipient).to eq("herbert@white.com")
      end
    end

    context "when the service is run several times in the same week" do
      it "only sends one email" do
        organiser_token = "41b783b5e27fb2eddd5456a182db56c4"
        event = create(
          :event,
          :occasional,
          organiser_token:,
          reminder_email_address: "herbert@white.com"
        )
        sender = described_class.new

        assert_emails 1 do
          sender.send!(event)
          travel 1.day
          sender.send!(event)
          travel 5.days
          sender.send!(event)
        end
      end
    end

    context "when the service is run twice with a week in-between" do
      it "sends two emails" do
        organiser_token = "41b783b5e27fb2eddd5456a182db56c4"
        event = create(
          :event,
          :occasional,
          organiser_token:,
          reminder_email_address: "herbert@white.com"
        )
        sender = described_class.new

        assert_emails 2 do
          sender.send!(event)
          travel 8.days
          sender.send!(event)
        end
      end
    end
  end
end

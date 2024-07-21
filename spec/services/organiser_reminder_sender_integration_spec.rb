# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrganiserReminderSender do
  include ActionMailer::TestHelper # assert_emails is defined in ActionMailer::TestHelper

  describe "INTEGRATION TEST" do
    it "sends a reminder email about the event" do
      event = create(:event, :occasional, title: "The Hot One", reminder_email_address: "herbert@white.com")
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

        expect(text_part).to include "We don't seem to have any future dates for your event: \"The Hot One\""
      end
    end
  end
end

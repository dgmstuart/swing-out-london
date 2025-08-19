# frozen_string_literal: true

require "rails_helper"
require "app/services/organiser_reminders_sender"

RSpec.describe OrganiserRemindersSender do
  include ActionMailer::TestHelper # assert_emails is defined in ActionMailer::TestHelper

  describe "send_unlisted" do
    around do |example|
      ClimateControl.modify(CANONICAL_HOST: "www.swingoutlondon.co.uk") { example.run }
    end

    context "when there are no events with organiser emails" do
      it "does nothing" do
        create_remindable_social(email: nil)

        described_class.new.send_unlisted

        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "when there are some emails to be sent" do
      it "sends emails to the organisers of events which have no future listed dates" do
        create_remindable_social(email: "a@example.com", title: "No dates", dates: [])
        create_remindable_social(email: "b@example.com", title: "With future dates", dates: [1.month.from_now])
        create_remindable_social(email: "c@example.com", title: "No future dates", dates: [1.month.ago])
        create_remindable_social(email: nil, title: "No future dates or email", dates: [1.month.ago])

        assert_emails 2 do
          described_class.new.send_unlisted
        end

        sent_emails = ActionMailer::Base.deliveries

        expect(sent_emails.map(&:subject)).to contain_exactly(
          match(/missing dates for "No dates"/),
          match(/missing dates for "No future dates"/)
        )
      end
    end

    def create_remindable_social(email:, title: "An event", dates: [])
      create(:social, :occasional, :with_organiser_token, reminder_email_address: email, title:, dates:)
    end
  end
end

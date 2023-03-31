# frozen_string_literal: true

require "rails_helper"

describe AdminMailer do
  describe "outdated" do
    context "when there are no outdated events" do
      it "renders the headers" do
        mail = described_class.outdated

        aggregate_failures do
          expect(mail.subject).to eq("All events in date")
          expect(mail.to).to eq(["swingoutlondon@gmail.com"])
          expect(mail.from).to eq(["swingoutlondon@gmail.com"])
        end
      end

      it "renders the body" do
        mail = described_class.outdated

        expect(mail.body.encoded).to match(Regexp.escape("All events are in date!"))
      end
    end

    context "when there are outdated and nearly outdated events" do
      it "renders the headers" do
        create(:event, id: 1, frequency: 4, dates: [Date.current - 4.weeks])
        create(:event, id: 2, frequency: 4, dates: [Date.current + 1.week])
        mail = described_class.outdated

        aggregate_failures do
          expect(mail.subject).to eq("1 event out of date, 1 event nearly out of date")
          expect(mail.to).to eq(["swingoutlondon@gmail.com"])
          expect(mail.from).to eq(["swingoutlondon@gmail.com"])
        end
      end

      it "includes links to the edit pages of those events" do
        outdated_event = create(:event, id: 1, frequency: 4, dates: [Date.current - 4.weeks])
        nearly_outdated_event = create(:event, id: 2, frequency: 4, dates: [Date.current + 1.week])
        mail = described_class.outdated

        aggregate_failures do
          expect(mail.body.encoded).to match "/events/#{outdated_event.to_param}/edit"
          expect(mail.body.encoded).to match "/events/#{nearly_outdated_event.to_param}/edit"
        end
      end

      it "includes links to the urls of those events" do
        outdated_event = create(:event, id: 1, frequency: 4, dates: [Date.current - 4.weeks])
        nearly_outdated_event = create(:event, id: 2, frequency: 4, dates: [Date.current + 1.week])
        mail = described_class.outdated

        aggregate_failures do
          expect(mail.body.encoded).to match outdated_event.url
          expect(mail.body.encoded).to match nearly_outdated_event.url
        end
      end

      it "includes the expected dates of out-of-date events" do
        create(:event, id: 1, frequency: 4, dates: [Date.current - 4.weeks])
        create(:event, id: 2, frequency: 4, dates: [Date.current + 1.week])
        mail = described_class.outdated

        expect(mail.body.encoded).to match Date.current.to_s(:listing_date)
      end

      it "includes headers for the two types of outdatedness" do
        create(:event, id: 1, frequency: 4, dates: [Date.current - 4.weeks])
        create(:event, id: 2, frequency: 4, dates: [Date.current + 1.week])
        mail = described_class.outdated

        aggregate_failures do
          expect(mail.body.encoded).to match("Out of date events")
          expect(mail.body.encoded).to match("Nearly out of date events")
        end
      end
    end
  end
end

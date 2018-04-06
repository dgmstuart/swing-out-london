require "rails_helper"

describe AdminMailer do
  describe "outdated" do
    let(:mail) { AdminMailer.outdated }

    context 'when there are no outdated events' do
      it "renders the headers" do
        expect(mail.subject).to eq("All events in date")
        expect(mail.to).to eq(["swingoutlondon@gmail.com"])
        expect(mail.from).to eq(["swingoutlondon@gmail.com"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match(Regexp.escape "All events are in date!")
      end
    end

    context 'when there are outdated and nearly outdated events' do
      before do
        @outdated_event = FactoryBot.create(:event, id: 1, frequency: 4, dates: [ Date.local_today - 4.weeks ])
        @nearly_outdated_event = FactoryBot.create(:event, id: 2, frequency: 4, dates: [ Date.local_today + 1.week ])
      end
      it "renders the headers" do
        expect(mail.subject).to eq("1 event out of date, 1 event nearly out of date")
        expect(mail.to).to eq(["swingoutlondon@gmail.com"])
        expect(mail.from).to eq(["swingoutlondon@gmail.com"])
      end

      it "includes links to the edit pages of those events" do
        expect(mail.body.encoded).to match "/events/#{@outdated_event.to_param}/edit"
        expect(mail.body.encoded).to match "/events/#{@nearly_outdated_event.to_param}/edit"
      end

      it "includes links to the urls of those events" do
        expect(mail.body.encoded).to match @outdated_event.url
        expect(mail.body.encoded).to match @nearly_outdated_event.url
      end

      it "includes the expected dates of out-of-date events" do
        expect(mail.body.encoded).to match Date.local_today.to_s(:listing_date)
      end

      it "includes headers for the two types of outdatedness" do
        expect(mail.body.encoded).to match("Out of date events")
        expect(mail.body.encoded).to match("Nearly out of date events")
      end
    end
  end
end

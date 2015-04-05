require "spec_helper"

describe AdminMailer do
  describe "outdated" do
    let(:mail) { AdminMailer.outdated }

    context 'when there are no outdated events' do
      it "renders the headers" do
        mail.subject.should eq("All events in date")
        mail.to.should eq(["swingoutlondon@gmail.com"])
        mail.from.should eq(["swingoutlondon@gmail.com"])
      end

      it "renders the body" do
        mail.body.encoded.should match(Regexp.escape "All events are in date!")
      end
    end

    context 'when there are outdated and nearly outdated events' do
      before do
        @outdated_event = FactoryGirl.build(:event, id: 1)
        @nearly_outdated_event = FactoryGirl.build(:event, id: 2)
        allow(Event).to receive(:out_of_date).and_return      [ @outdated_event ]
        allow(Event).to receive(:near_out_of_date).and_return [ @nearly_outdated_event ]
      end
      it "renders the headers" do
        mail.subject.should eq("1 event out of date, 1 event nearly out of date")
        mail.to.should eq(["swingoutlondon@gmail.com"])
        mail.from.should eq(["swingoutlondon@gmail.com"])
      end

      it "includes links to the edit pages of those events" do
        mail.body.encoded.should match "/events/#{@outdated_event.to_param}/edit"
        mail.body.encoded.should match "/events/#{@nearly_outdated_event.to_param}/edit"
      end

      it "includes links to the urls of those events" do
        mail.body.encoded.should match @outdated_event.url
        mail.body.encoded.should match @nearly_outdated_event.url
      end

      it "includes headers for the two types of outdatedness" do
        mail.body.encoded.should match("Out of date events")
        mail.body.encoded.should match("Nearly out of date events")
      end
    end
  end
end

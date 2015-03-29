require "spec_helper"

describe AdminMailer do
  describe "outdated" do
    let(:mail) { AdminMailer.outdated }

    it "renders the headers" do
      mail.subject.should eq("All events in date")
      mail.to.should eq(["swingoutlondon@gmail.com"])
      mail.from.should eq(["swingoutlondon@gmail.com"])
    end

    it "renders the body" do
      pending "Body tests" do
        mail.body.encoded.should match()
      end
    end
  end

end

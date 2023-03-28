# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event do
  describe "#out_of_date" do
    context "when the event has no dates" do
      let(:event) { create(:event, dates: []) }

      it "is true" do
        expect(event.out_of_date).to be true
      end
    end

    context "when the event has one date in the future" do
      let(:event) { create(:event, dates: [Time.zone.today + 1]) }

      it "is false" do
        expect(event.out_of_date).to be false
      end
    end

    context "when the event has one date in the past" do
      let(:event) { create(:event, dates: [Time.zone.today - 2]) }

      it "is true" do
        expect(event.out_of_date).to be true
      end
    end

    context "when the event is weekly" do
      let(:event) { create(:event, frequency: 1, dates: []) }

      it "is false" do
        expect(event.out_of_date).to be false
      end
    end

    context "when the event has an end date" do
      let(:event) { create(:event, dates: [], last_date: (Time.zone.today + 1.year)) }

      it "is false" do
        expect(event.out_of_date).to be false
      end
    end
  end
end

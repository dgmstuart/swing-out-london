require 'rails_helper'

RSpec.describe Event do
  describe "#out_of_date" do
    context 'when the event has no dates' do
      let(:event) { FactoryBot.create(:event, dates: []) }
      it "is true" do
        expect(event.out_of_date).to eq true
      end
    end

    context 'when the event has one date in the future' do
      let(:event) { FactoryBot.create(:event, dates: [Date.today + 1] ) }
      it "is false" do
        expect(event.out_of_date).to eq false
      end
    end

    context 'when the event has one date in the past' do
      let(:event) { FactoryBot.create(:event, dates: [Date.today - 1]) }
      it "is true" do
        expect(event.out_of_date).to eq true
      end
    end

    context 'when the event is weekly' do
      let(:event) { FactoryBot.create(:event, frequency: 1, dates: []) }
      it "is false" do
        expect(event.out_of_date).to eq false
      end
    end

    context 'when the event has an end date' do
      let(:event) { FactoryBot.create(:event, dates: [], last_date: (Date.today + 1.year)) }
      it "is false" do
        expect(event.out_of_date).to eq false
      end
    end

    context 'when the event is out of date and happens every 6 months' do
      context 'but the next expected event is more than 6 weeks away' do
        let(:event) { FactoryBot.create(:event, frequency: 26, dates: [Date.today - 1]) }
        it "is false" do
          expect(event.out_of_date).to eq false
        end
      end
      context 'and the next expected event is less than 6 weeks away' do
        let(:event) { FactoryBot.create(:event, frequency: 26, dates: [Date.today - (20.weeks + 2.days)]) }
        it "is true" do
          expect(event.out_of_date).to eq true
        end
      end
    end
  end

  describe "#near_out_of_date" do
    context 'when the event has no dates' do
      # BUG! This is actually out of date, not near out of date

      let(:event) { FactoryBot.create(:event, dates: []) }
      it "is true" do
        expect(event.near_out_of_date).to eq true
      end
    end

    context 'when the event has one date in the near future' do
      let(:event) { FactoryBot.create(:event, dates: [Date.today + 1] ) }
      it "is true" do
        expect(event.near_out_of_date).to eq true
      end
    end

    context 'when the event has one date in the far future' do
      let(:event) { FactoryBot.create(:event, dates: [Date.today + 14] ) }
      it "is true" do
        expect(event.near_out_of_date).to eq false
      end
    end

    context 'when the event has one date in the past' do
      # BUG! This is actually out of date, not near out of date

      let(:event) { FactoryBot.create(:event, dates: [Date.today - 1]) }
      it "is true" do
        expect(event.near_out_of_date).to eq true
      end
    end

    context 'when the event is weekly' do
      let(:event) { FactoryBot.create(:event, frequency: 1, dates: []) }
      it "is false" do
        expect(event.near_out_of_date).to eq false
      end
    end

    context 'when the event has an end date' do
      let(:event) { FactoryBot.create(:event, dates: [], last_date: (Date.today + 1.year)) }
      it "is false" do
        expect(event.near_out_of_date).to eq false
      end
    end

    context 'when the event is out of date and happens every 6 months' do
      context 'but the next expected event is more than 6 weeks away' do
        let(:event) { FactoryBot.create(:event, frequency: 26, dates: [Date.today - 1.month]) }
        it "is false" do
          expect(event.near_out_of_date).to eq false
        end
      end
      context 'and the next expected event is less than 6 weeks away' do
        let(:event) { FactoryBot.create(:event, frequency: 26, dates: [Date.today - (20.weeks + 2.days)]) }
        it "is true" do
          expect(event.near_out_of_date).to eq true
        end
      end
    end

  end
end

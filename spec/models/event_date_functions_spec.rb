# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event do
  describe '#out_of_date' do
    context 'when the event has no dates' do
      let(:event) { create(:event, dates: []) }

      it 'is true' do
        expect(event.out_of_date).to be true
      end
    end

    context 'when the event has one date in the future' do
      let(:event) { create(:event, dates: [Time.zone.today + 1]) }

      it 'is false' do
        expect(event.out_of_date).to be false
      end
    end

    context 'when the event has one date in the past' do
      let(:event) { create(:event, dates: [Time.zone.today - 2]) }

      it 'is true' do
        expect(event.out_of_date).to be true
      end
    end

    context 'when the event is weekly' do
      let(:event) { create(:event, frequency: 1, dates: []) }

      it 'is false' do
        expect(event.out_of_date).to be false
      end
    end

    context 'when the event has an end date' do
      let(:event) { create(:event, dates: [], last_date: (Time.zone.today + 1.year)) }

      it 'is false' do
        expect(event.out_of_date).to be false
      end
    end

    context 'when the event is out of date and happens every 6 months' do
      it 'is false if the next expected event is more than 6 weeks away' do
        event = create(:event, frequency: 26, dates: [Time.zone.today - 1])
        expect(event.out_of_date).to be false
      end

      it 'is true if the next expected event is less than 6 weeks away' do
        event = create(:event, frequency: 26, dates: [Time.zone.today - (20.weeks + 2.days)])
        expect(event.out_of_date).to be true
      end
    end
  end

  describe '#near_out_of_date' do
    context 'when the event has no dates' do
      # BUG! This is actually out of date, not near out of date

      let(:event) { create(:event, dates: []) }

      it 'is true' do
        expect(event.near_out_of_date).to be true
      end
    end

    context 'when the event has one date in the near future' do
      let(:event) { create(:event, dates: [Time.zone.today + 1]) }

      it 'is true' do
        expect(event.near_out_of_date).to be true
      end
    end

    context 'when the event has one date in the far future' do
      let(:event) { create(:event, dates: [Time.zone.today + 14]) }

      it 'is true' do
        expect(event.near_out_of_date).to be false
      end
    end

    context 'when the event has one date in the past' do
      # BUG! This is actually out of date, not near out of date

      let(:event) { create(:event, dates: [Time.zone.today - 1]) }

      it 'is true' do
        expect(event.near_out_of_date).to be true
      end
    end

    context 'when the event is weekly' do
      let(:event) { create(:event, frequency: 1, dates: []) }

      it 'is false' do
        expect(event.near_out_of_date).to be false
      end
    end

    context 'when the event has an end date' do
      let(:event) { create(:event, dates: [], last_date: (Time.zone.today + 1.year)) }

      it 'is false' do
        expect(event.near_out_of_date).to be false
      end
    end

    context 'when the event is out of date and happens every 6 months' do
      it 'is false if the next expected event is more than 6 weeks away' do
        event = create(:event, frequency: 26, dates: [Time.zone.today - 1.month])
        expect(event.near_out_of_date).to be false
      end

      it 'is true if the next expected event is less than 6 weeks away' do
        event = create(:event, frequency: 26, dates: [Time.zone.today - (20.weeks + 2.days)])
        expect(event.near_out_of_date).to be true
      end
    end
  end
end

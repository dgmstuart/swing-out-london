# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventUpdater do
  describe "#update!" do
    it "builds an event with the passed in params, except dates and cancellations" do
      record = instance_double("Event", update!: double, reload: double)
      other_value = double
      params = { dates: [], cancellations: [], other: other_value }

      described_class.new(record).update!(params)

      expect(record).to have_received(:update!).with(
        { other: other_value, swing_dates: [], swing_cancellations: [] }
      )
    end

    it "returns the updated event" do
      record = create(:event)
      params = attributes_for(:event, title: "something different")

      result = described_class.new(record).update!(params)

      expect(result.title).to eq "something different"
    end

    context "when there are dates" do
      it "creates SwingDate records from the dates" do
        record = create(:event)
        date1 = Date.tomorrow
        date2 = 2.days.from_now.to_date
        params = attributes_for(:event).merge(dates: [date1, date2])

        event = described_class.new(record).update!(params)

        expect(event.swing_dates.map(&:date)).to contain_exactly(date1, date2)
      end
    end

    context "when there are cancellations" do
      it "creates SwingDate records from the cancellations" do
        record = create(:event)
        date1 = Date.tomorrow
        date2 = 2.days.from_now.to_date
        params = attributes_for(:event).merge(cancellations: [date1, date2])

        event = described_class.new(record).update!(params)

        expect(event.swing_cancellations.map(&:date)).to contain_exactly(date1, date2)
      end
    end

    context "when removing dates" do
      it "removes the relevant EventSwingDate records from the dates" do
        date1 = Date.tomorrow
        date2 = 2.days.from_now.to_date
        record = create(:event, swing_dates: [build(:swing_date, date: date1), build(:swing_date, date: date2)])
        params = attributes_for(:event).merge(dates: [date1])

        event = described_class.new(record).update!(params)

        expect(event.swing_dates.map(&:date)).to contain_exactly(date1)
      end
    end

    context "when the dates already exist" do
      it "uses the existing dates" do # rubocop:disable RSpec.example_length
        record = create(:event)
        date = Date.tomorrow
        swing_date = create(:swing_date, date:)
        params = attributes_for(:event).merge(dates: [date], cancellations: [date])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.swing_dates).to eq [swing_date]
            expect(event.swing_cancellations).to eq [swing_date]
          end.not_to change(SwingDate, :count)
        end
      end
    end

    context "when no cancellations or dates are passed" do
      it "builds an event" do
        record = instance_double("Event", update!: double, reload: double)
        other_value = double
        params = { other: other_value }

        described_class.new(record).update!(params)

        expect(record).to have_received(:update!).with(
          { other: other_value }
        )
      end
    end
  end
end

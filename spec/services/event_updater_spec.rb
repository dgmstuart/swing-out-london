# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventUpdater do
  describe "#update!" do
    it "builds an event with the passed in params, except dates and cancellations" do
      record = create(:event)
      allow(record).to receive(:update!)
      other_value = double
      params = { dates: [], cancellations: [], frequency: 0, title: other_value }

      described_class.new(record).update!(params)

      expect(record).to have_received(:update!).with(
        { title: other_value, frequency: 0, event_instances: [] }
      )
    end

    context "when the frequency isn't being updated" do
      it "uses the frequency from the event record." do
        record = create(:event, :weekly)
        allow(record).to receive(:update!)
        params = { dates: [], cancellations: [] }

        described_class.new(record).update!(params)

        expect(record).to have_received(:update!).with({ event_instances: [] })
      end
    end

    it "returns the updated event" do
      record = create(:event)
      params = attributes_for(:event, title: "something different")

      result = described_class.new(record).update!(params)

      expect(result.title).to eq "something different"
    end

    context "when there are dates" do
      it "creates event instances from the dates" do # rubocop:disable RSpec/ExampleLength
        record = create(:event)
        date1 = Date.parse("1940-11-13")
        date2 = Date.parse("1940-11-14")
        params = attributes_for(:event, :occasional).merge(dates: [date1, date2])

        Timecop.freeze("1940-11-01") do
          event = described_class.new(record).update!(params)

          aggregate_failures do
            expect(event.event_instances.map(&:date)).to contain_exactly(date1, date2)
            expect(event.audits.last.comment).to eq "Updated dates: (old: ) (new: 13/11/1940,14/11/1940)"
          end
        end
      end
    end

    context "when there are cancellations for an occasional event" do
      it "creates cancelled event instances from the cancellations" do # rubocop:disable RSpec/ExampleLength
        record = create(:event)
        date1 = Date.parse("1940-11-13")
        date2 = Date.parse("1940-11-14")
        params = attributes_for(:event, :occasional).merge(dates: [date1, date2], cancellations: [date1, date2])

        Timecop.freeze("1940-11-01") do
          event = described_class.new(record).update!(params)

          aggregate_failures do
            instances = event.event_instances
            expect(instances.map(&:date)).to contain_exactly(date1, date2)
            expect(instances.map(&:cancelled)).to contain_exactly(true, true)
          end
        end
      end
    end

    context "when there are cancellations for a weekly event" do
      it "creates cancelled event instances from the cancellations" do # rubocop:disable RSpec/ExampleLength
        record = create(:event)
        date1 = Date.parse("1940-11-13")
        date2 = Date.parse("1940-11-14")
        params = attributes_for(:event, :weekly).merge(cancellations: [date1, date2])

        Timecop.freeze("1940-11-01") do
          event = described_class.new(record).update!(params)

          aggregate_failures do
            instances = event.event_instances
            expect(instances.map(&:date)).to contain_exactly(date1, date2)
            expect(instances.map(&:cancelled)).to contain_exactly(true, true)
          end
        end
      end
    end

    context "when removing dates" do
      it "removes the relevant EventInstance records" do
        date1 = Date.tomorrow
        date2 = 2.days.from_now.to_date
        record = create(:event, event_instances: [build(:event_instance, date: date1), build(:event_instance, date: date2)])
        params = attributes_for(:event, :occasional).merge(dates: [date1])

        event = described_class.new(record).update!(params)

        expect(event.event_instances.map(&:date)).to contain_exactly(date1)
      end
    end

    context "when a matching instance already exists" do
      it "uses the existing instance" do
        record = create(:event)
        date = Date.tomorrow
        event_instance = create(:event_instance, event: record, date:)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances).to eq [event_instance]
          end.not_to change(EventInstance, :count)
        end
      end
    end

    context "when an instance already exists matching the date but not the event ID" do
      it "creates a new instance" do # .example_length
        record = create(:event)
        date = Date.tomorrow
        event_instance = create(:event_instance, event: build(:event), date:)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances.map(&:id)).not_to eq [event_instance.id]
            expect(event.event_instances.pluck(:event_id, :date)).to eq [[record.id, date]]
          end.to change(EventInstance, :count).by(1)
        end
      end
    end

    context "when a cancelled instance already exists" do
      it "is still cancelled" do
        record = create(:event)
        date = Date.tomorrow
        create(:event_instance, event: record, date:, cancelled: true)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [date])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances.map(&:cancelled)).to eq [true]
          end.not_to change(EventInstance, :count)
        end
      end
    end

    context "when a cancelled instance already exists, and cancellations are empty" do
      it "is no longer cancelled" do
        record = create(:event)
        date = Date.tomorrow
        create(:event_instance, event: record, date:, cancelled: true)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances.map(&:cancelled)).to eq [false]
          end.not_to change(EventInstance, :count)
        end
      end
    end

    context "when a non-cancelled instance already exists, and should now be cancelled" do
      it "is now cancelled" do
        record = create(:event)
        date = Date.tomorrow
        create(:event_instance, event: record, date:, cancelled: false)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [date])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances.map(&:cancelled)).to eq [true]
          end.not_to change(EventInstance, :count)
        end
      end
    end

    context "when switching from occasional to weekly" do
      it "removes any existing date records" do # .example_length
        date = Date.tomorrow
        record = create(:event, :occasional)
        create(:event_instance, event: record, date:, cancelled: true)
        create(:event_instance, event: record, date: 1.week.from_now.to_date, cancelled: false)
        # We shouldn't ever receive `dates` for weekly events (the form handles that),
        # but let's be safe and test what happens when we do:
        params = attributes_for(:event, :weekly).merge(dates: [date], cancellations: [date])

        aggregate_failures do
          expect do
            event = described_class.new(record).update!(params)
            expect(event.event_instances.map(&:cancelled)).to eq [true]
          end.to change(EventInstance, :count).from(2).to(1)
        end
      end
    end

    context "when switching from occasional to weekly with no dates" do
      it "removes any existing date records" do
        date = Date.tomorrow
        record = create(:event, :occasional)
        create(:event_instance, event: record, date:, cancelled: true)
        create(:event_instance, event: record, date: 1.week.from_now.to_date, cancelled: false)
        # In reality we always post the whole form, so we should never end up with params without any date key,
        # but let's be safe and test what happens when we do:
        expect do
          params = attributes_for(:event, :weekly)
          described_class.new(record).update!(params)
        end.to raise_error(ActiveRecord::RecordInvalid, /Event instances must all be cancelled for weekly events/)
      end
    end

    context "when the event was invalid" do
      it "no changes to event instances are persisted" do # .example_length
        record = create(:event)
        date1 = Date.tomorrow
        date2 = 2.days.from_now
        create(:event_instance, event: record, date: date1, cancelled: false)
        params = attributes_for(:event, :occasional)
                 .merge(url: "not a valid url", dates: [date1, date2], cancellations: [date1])

        aggregate_failures do
          expect do
            described_class.new(record).update!(params)
          end.to raise_error(ActiveRecord::RecordInvalid)
          expect(record.reload.event_instances.map(&:cancelled)).to eq [false]
        end
      end
    end

    context "when no cancellations or dates are passed" do
      it "builds an event" do
        record = instance_double("Event", update!: double, reload: double, event_instances: [])
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

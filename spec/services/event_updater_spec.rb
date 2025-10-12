# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventUpdater do
  describe "#update!" do
    it "updates event with the given attributes" do
      record = create(:event,  title: "Stomp", url: "https://example.com")
      params = { title: "Bounce", url: "https://exemplary.se" }

      described_class.new(record).update!(params)

      expect(record.reload).to have_attributes(
        title: "Bounce",
        url: "https://exemplary.se"
      )
    end

    context "when the frequency isn't being updated" do
      it "uses the frequency from the event record." do
        record = create(:event, :weekly)
        params = { dates: [], cancellations: [] }

        described_class.new(record).update!(params)

        expect(record.reload).to be_weekly
      end
    end

    it "returns the updated event" do
      record = create(:event)
      params = attributes_for(:event, title: "something different")

      result = described_class.new(record).update!(params)

      expect(result.title).to eq "something different"
    end

    context "when there are dates" do
      it "creates event instances from the dates" do
        record = create(:event)
        date1 = Date.parse("2012-11-13")
        date2 = Date.parse("2012-11-14")
        params = attributes_for(:event, :occasional).merge(dates: [date1, date2])

        event = described_class.new(record).update!(params)

        aggregate_failures do
          expect(event.event_instances.map(&:date)).to contain_exactly(date1, date2)
          expect(event.audits.last.comment).to eq "Updated dates: (old: ) (new: 13/11/2012,14/11/2012)"
        end
      end
    end

    context "when there are cancellations for an occasional event" do
      it "creates cancelled event instances from the cancellations" do
        record = create(:event)
        date1 = Date.parse("2012-11-13")
        date2 = Date.parse("2012-11-14")
        params = attributes_for(:event, :occasional).merge(dates: [date1, date2], cancellations: [date1, date2])

        event = described_class.new(record).update!(params)

        aggregate_failures do
          instances = event.event_instances
          expect(instances.map(&:date)).to contain_exactly(date1, date2)
          expect(instances.map(&:cancelled)).to contain_exactly(true, true)
        end
      end
    end

    context "when there are cancellations for a weekly event" do
      it "creates cancelled event instances from the cancellations" do
        record = create(:event)
        date1 = Date.parse("2012-11-13")
        date2 = Date.parse("2012-11-14")
        params = attributes_for(:event, :weekly).merge(cancellations: [date1, date2])

        event = described_class.new(record).update!(params)

        aggregate_failures do
          instances = event.event_instances
          expect(instances.map(&:date)).to contain_exactly(date1, date2)
          expect(instances.map(&:cancelled)).to contain_exactly(true, true)
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

    context "when cancelling a non-cancelled instance" do
      it "updates the existing instance" do
        record = create(:event)
        date = Date.tomorrow
        create(:event_instance, event: record, date:)
        params = attributes_for(:event, :occasional).merge(dates: [date], cancellations: [date])

        described_class.new(record).update!(params)

        expect(EventInstance.sole.cancelled).to be(true)
      end
    end

    context "when an instance already exists matching the date but not the event ID" do
      it "creates a new instance" do
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

    context "when empty cancellations and dates are passed" do
      it "removes any existing instances" do
        record = create(:event, dates: [Date.parse("2012-01-07")], cancellations: [Date.parse("2012-01-14")])
        params = { dates: [], cancellations: [] }

        described_class.new(record).update!(params)

        expect(record.reload.event_instances).to be_empty
      end
    end

    context "when no cancellations or dates are passed [EDGE CASE]" do
      # Edge case because in reality we always pass canellations and dates
      it "doesn't remove any existing instances" do
        record = create(:event, dates: [Date.parse("2012-01-07")], cancellations: [Date.parse("2012-01-14")])
        params = {}

        described_class.new(record).update!(params)

        expect(record.reload.event_instances.count).to eq(2)
      end
    end

    context "when saving the event fails" do
      it "doesn't change any instances" do
        record = create(:event)
        params = attributes_for(:event, :occasional)
                 .merge(dates: [Date.parse("2012-11-13")], url: nil) # invalid because url is nil

        aggregate_failures do
          expect(record.event_instances).to be_empty

          expect { described_class.new(record).update!(params) }
            .to raise_error(ActiveRecord::RecordInvalid)

          expect(record.reload.event_instances).to be_empty
        end
      end
    end

    context "when saving an event instance fails [EDGE CASE]" do
      it "doesn't change the event" do
        record = create(:event, title: "stomp")
        create(:event_instance, event: record, date: Date.parse("2012-06-01"), cancelled: false)
        params = attributes_for(:event, :occasional).merge(
          dates: [Date.parse("1940-11-13"), Date.parse("2012-06-01")],
          cancellations: [Date.parse("2012-06-01")],
          title: "bounce"
        ) # invalid because one date is too far in the past

        aggregate_failures do
          expect(record.event_instances.sole.cancelled).to be false

          expect { described_class.new(record).update!(params) }
            .to raise_error(ActiveRecord::RecordInvalid)

          expect(record.reload.title).to eq("stomp")
          expect(record.reload.event_instances.count).to eq 1
          expect(record.event_instances.sole.cancelled).to be false
        end
      end
    end

    context "when hiatus params are passed" do
      it "creates a hiatus" do
        record = create(:event)
        params = attributes_for(:event, :weekly)
                 .merge(start_of_break: Date.parse("2025-10-07"), first_date_back: Date.parse("2025-10-14"))

        result = described_class.new(record).update!(params)

        expect(result.event_hiatuses.sole).to have_attributes(
          start_date: Date.parse("2025-10-07"),
          return_date: Date.parse("2025-10-14")
        )
      end
    end
  end
end

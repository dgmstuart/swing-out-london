# frozen_string_literal: true

require "rails_helper"

describe SocialsListings do
  describe "Integration tests:" do
    describe "#build" do
      context "when there is only one social" do
        it "returns the correct array when that social has only one date in the future" do
          event = create(:intermittent_social, dates: ["10 June 1935".to_date])

          dates = Event.listing_dates("1 June 1935".to_date)
          result = described_class.new.build(dates)

          expect(result).to eq([["10 June 1935".to_date, [event], []]])
        end

        it "returns the correct array when that social has a cancellation" do
          event = create(:intermittent_social, dates: ["10 June 1935".to_date, "12 June 1935".to_date])
          event.update!(cancellations: ["12 June 1935".to_date])

          dates = Event.listing_dates("1 June 1935".to_date)
          result = described_class.new.build(dates)

          expect(result).to eq(
            [
              ["10 June 1935".to_date, [event], []],
              ["12 June 1935".to_date, [event], [event.id]]
            ]
          )
        end

        it "returns the correct array when that social has two dates in the future" do
          event = create(:intermittent_social, dates: ["17 June 1935".to_date, "10 June 1935".to_date])

          dates = Event.listing_dates("4 June 1935".to_date)
          result = described_class.new.build(dates)

          expect(result).to eq(
            [
              ["10 June 1935".to_date, [event], []],
              ["17 June 1935".to_date, [event], []]
            ]
          )
        end

        it "returns the correct array when that social has one date today, one at the limit and one outside the limit" do
          lower_limit_date = Time.zone.today
          upper_limit_date = Time.zone.today + 13
          outside_limit_date = Time.zone.today + 14
          event = create(:intermittent_social, dates: [upper_limit_date, outside_limit_date, lower_limit_date])

          dates = Event.listing_dates(Time.zone.today)
          result = described_class.new.build(dates)

          expect(result).to eq(
            [[lower_limit_date, [event], []], [upper_limit_date, [event], []]]
          )
        end

        it "returns the correct array when that social has one date in the future and one in the past" do
          past_date = Time.zone.today - 1.month
          future_date = Time.zone.today + 5
          event = create(:intermittent_social, dates: [past_date, future_date])

          dates = Event.listing_dates(Time.zone.today)
          result = described_class.new.build(dates)

          expect(result).to eq([[future_date, [event], []]])
        end
      end

      context "when there is a weekly event and two occasional events on the same day" do
        it "returns an array with both events on that day, sorted alphabetically" do # rubocop:disable RSpec/ExampleLength
          roseland = create(:social, title: "Roseland Tuesdays", frequency: 1, day: "Tuesday")
          battle = create(:social, title: "Battle of the bands", frequency: 0, dates: ["May 11 1937".to_date])
          stomping = create(:social, title: "Stomping at the Cotton club", frequency: 0, dates: ["May 18 1937".to_date])

          dates = Event.listing_dates("May 10 1937".to_date)
          result = described_class.new.build(dates)

          expect(result).to eq(
            [
              ["May 11 1937".to_date, [battle, roseland], []],
              ["May 18 1937".to_date, [roseland, stomping], []]
            ]
          )
        end
      end

      context "when things are complex" do
        def date(offset)
          Time.zone.today + offset
        end

        it "returns the correct array with a bunch of classes and socials" do # rubocop:disable RSpec/ExampleLength
          # create one class for each day, starting on monday. None of these should be included
          create_list(:class, 7)

          # not included events:
          create(:intermittent_social, dates: [date(-10)])
          create(:intermittent_social, dates: [date(-370)])
          create(:intermittent_social, dates: [date(20)])

          # included events:
          event_d1 = create(:intermittent_social, dates: [date(1)])
          event_d10_d11 = create(:social, frequency: 4, dates: [date(10), date(11)])
          event_1_d8 = create(:social, frequency: 4, dates: [date(8)], title: "A")
          event_2_d8 = create(:social, frequency: 2, dates: [date(8)], title: "Z")

          dates = Event.listing_dates(Time.zone.today)
          result = described_class.new.build(dates)

          expect(result).to eq(
            [
              [date(1), [event_d1], []],
              [date(8), [event_1_d8, event_2_d8], []],
              [date(10), [event_d10_d11], []],
              [date(11), [event_d10_d11], []]
            ]
          )
        end
      end
    end
  end
end

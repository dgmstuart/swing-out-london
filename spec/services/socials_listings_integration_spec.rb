# frozen_string_literal: true

require "rails_helper"

RSpec.describe SocialsListings do
  describe "Integration tests:" do
    describe "#build" do
      context "when there is only one social" do
        it "returns the correct array when that social has only one date in the future" do
          create(:intermittent_social, dates: ["10 June 1935".to_date], title: "Swing pit")

          dates = SOLDNTime.listing_dates("1 June 1935".to_date)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq([["10 June 1935".to_date, [["Swing pit", false]]]])
        end

        it "returns the correct array when that social has a cancellation" do
          event = create(:intermittent_social, dates: ["10 June 1935".to_date, "12 June 1935".to_date], title: "Swing pit")
          event.update!(cancellations: ["12 June 1935".to_date])

          dates = SOLDNTime.listing_dates("1 June 1935".to_date)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq(
            [
              ["10 June 1935".to_date, [["Swing pit", false]]],
              ["12 June 1935".to_date, [["Swing pit", true]]]
            ]
          )
        end

        it "returns the correct array when that social has two dates in the future" do
          create(:intermittent_social, dates: ["17 June 1935".to_date, "10 June 1935".to_date], title: "Swing pit")

          dates = SOLDNTime.listing_dates("4 June 1935".to_date)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq(
            [
              ["10 June 1935".to_date, [["Swing pit", false]]],
              ["17 June 1935".to_date, [["Swing pit", false]]]
            ]
          )
        end

        it "returns the correct array when that social has one date today, one at the limit and one outside the limit" do
          lower_limit_date = Time.zone.today
          upper_limit_date = Time.zone.today + 13
          outside_limit_date = Time.zone.today + 14
          create(:intermittent_social, dates: [upper_limit_date, outside_limit_date, lower_limit_date], title: "Swing pit")

          dates = SOLDNTime.listing_dates(Time.zone.today)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq(
            [[lower_limit_date, [["Swing pit", false]]], [upper_limit_date, [["Swing pit", false]]]]
          )
        end

        it "returns the correct array when that social has one date in the future and one in the past" do
          past_date = Time.zone.today - 1.month
          future_date = Time.zone.today + 5
          create(:intermittent_social, dates: [past_date, future_date], title: "Swing pit")

          dates = SOLDNTime.listing_dates(Time.zone.today)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq([[future_date, [["Swing pit", false]]]])
        end
      end

      context "when there is a weekly event and two occasional events on the same day" do
        it "returns an array with both events on that day, sorted alphabetically" do # rubocop:disable RSpec/ExampleLength
          create(:social, title: "Roseland Tuesdays", frequency: 1, day: "Tuesday")
          create(:social, title: "Battle of the bands", frequency: 0, dates: ["May 11 1937".to_date])
          create(:social, title: "Stomping at the Cotton club", frequency: 0, dates: ["May 18 1937".to_date])

          dates = SOLDNTime.listing_dates("May 10 1937".to_date)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq(
            [
              ["May 11 1937".to_date, [["Battle of the bands", false], ["Roseland Tuesdays", false]]],
              ["May 18 1937".to_date, [["Roseland Tuesdays", false], ["Stomping at the Cotton club", false]]]
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
          create(:intermittent_social, dates: [date(1)], title: "Tomorrow")
          create(:social, frequency: 4, dates: [date(10), date(11)], title: "Twice")
          create(:social, frequency: 4, dates: [date(8)], title: "Shown last")
          create(:social, frequency: 2, dates: [date(8)], title: "Shown first")

          dates = SOLDNTime.listing_dates(Time.zone.today)
          result = described_class.new(presenter_class: test_presenter).build(dates)

          expect(result).to eq(
            [
              [date(1), [["Tomorrow", false]]],
              [date(8), [["Shown first", false], ["Shown last", false]]],
              [date(10), [["Twice", false]]],
              [date(11), [["Twice", false]]]
            ]
          )
        end
      end

      def test_presenter
        # instead of creating an instance, just print the event title and cancelled status
        Class.new do
          class << self
            def new(event, cancelled:)
              [event.title, cancelled]
            end
          end
        end
      end
    end
  end
end

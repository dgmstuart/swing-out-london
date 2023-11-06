# frozen_string_literal: true

require "spec_helper"
require "app/models/soldn_time"
require "active_support/testing/time_helpers"
require "active_support/core_ext/string/zones"
require "active_support/core_ext/numeric/time"
require "spec/support/time_formats_helper"

RSpec.describe SOLDNTime, :time do
  include ActiveSupport::Testing::TimeHelpers

  describe "today" do
    context "when the timezone is UTC" do
      around do |example|
        Time.use_zone("UTC") { example.run }
      end

      context "when the time is before midnight" do
        it "is the current date" do
          travel_to(Time.zone.parse("May 11, 1938 19:00"))

          expect(described_class.today.to_fs).to eq "11/05/1938"
        end
      end

      context "when the time is before 4am" do
        it "is the date that this crazy night began (yesterday's date)" do
          travel_to(Time.zone.parse("May 12, 1938 03:59"))

          expect(described_class.today.to_fs).to eq "11/05/1938"
        end
      end

      context "when the time is 4am" do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse("May 12, 1938 04:00"))

          expect(described_class.today.to_fs).to eq "12/05/1938"
        end
      end
    end

    context "when the timezone is BST" do
      around do |example|
        Time.use_zone("London") { example.run }
      end

      context "when the time is before 4am" do
        it "is the date that this crazy night began (yesterday's date)" do
          travel_to(Time.zone.parse("May 12, 1938 03:59"))

          expect(described_class.today.to_fs).to eq "11/05/1938"
        end
      end

      context "when the time is 4am" do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse("May 12, 1938 04:00"))

          expect(described_class.today.to_fs).to eq "12/05/1938"
        end
      end

      context "when the time is 5am" do
        it "is time to go to bed (today's date)" do
          travel_to(Time.zone.parse("May 12, 1938 05:00"))

          expect(described_class.today.to_fs).to eq "12/05/1938"
        end
      end
    end
  end

  describe ".listing_dates" do
    context "when the number of days is 2" do
      it "returns an array of the first date and the day after" do
        result = described_class.listing_dates("1st January 1928".to_date, number_of_days: 2)

        expect(result).to eq(
          [
            "1st January 1928",
            "2nd January 1928"
          ].map(&:to_date)
        )
      end
    end

    context "when the number of days is not specified" do
      it "defaults to showing 14 days" do # rubocop:disable RSpec/ExampleLength
        result = described_class.listing_dates("1st January 1928".to_date)

        expect(result).to eq(
          [
            "1st January 1928",
            "2nd January 1928",
            "3rd January 1928",
            "4th January 1928",
            "5th January 1928",
            "6th January 1928",
            "7th January 1928",
            "8th January 1928",
            "9th January 1928",
            "10th January 1928",
            "11th January 1928",
            "12th January 1928",
            "13th January 1928",
            "14th January 1928"
          ].map(&:to_date)
        )
      end
    end

    context "when the start date is not specified" do
      around do |example|
        Time.use_zone("UTC") { example.run }
      end

      it "defaults to today" do
        travel_to(Time.zone.parse("Jan 1, 1928 19:00"))

        result = described_class.listing_dates(number_of_days: 1)

        expect(result).to eq(["1st January 1928".to_date])
      end
    end
  end
end

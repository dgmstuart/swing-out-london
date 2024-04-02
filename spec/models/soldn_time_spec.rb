# frozen_string_literal: true

require "spec_helper"
require "app/models/soldn_time"
require "timecop"
require "spec/support/time_formats_helper"
require "active_support/core_ext/string/zones"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/blank"

RSpec.describe SOLDNTime, :time do
  describe "today" do
    context "when the timezone is UTC" do
      around do |example|
        Time.use_zone("UTC") { example.run }
        Timecop.return
      end

      context "when the time is before midnight" do # rubocop:disable RSpec/NestedGroups
        it "is the current date" do
          Timecop.travel(Time.zone.parse("May 11, 1938 19:00"))

          expect(described_class.today.to_s).to eq "1938-05-11"
        end
      end

      context "when the time is before 4am" do # rubocop:disable RSpec/NestedGroups
        it "is the date that this crazy night began (yesterday's date)" do
          Timecop.travel(Time.zone.parse("May 12, 1938 03:59"))

          expect(described_class.today.to_s).to eq "1938-05-11"
        end
      end

      context "when the time is 4am" do # rubocop:disable RSpec/NestedGroups
        it "is time to go to bed (today's date)" do
          Timecop.travel(Time.zone.parse("May 12, 1938 04:00"))

          expect(described_class.today.to_s).to eq "1938-05-12"
        end
      end
    end

    context "when the timezone is BST" do
      around do |example|
        Time.use_zone("London") { example.run }
        Timecop.return
      end

      context "when the time is before 4am" do # rubocop:disable RSpec/NestedGroups
        it "is the date that this crazy night began (yesterday's date)" do
          Timecop.travel(Time.zone.parse("May 12, 1938 03:59"))

          expect(described_class.today.to_s).to eq "1938-05-11"
        end
      end

      context "when the time is 4am" do # rubocop:disable RSpec/NestedGroups
        it "is time to go to bed (today's date)" do
          Timecop.travel(Time.zone.parse("May 12, 1938 04:00"))

          expect(described_class.today.to_s).to eq "1938-05-12"
        end
      end

      context "when the time is 5am" do # rubocop:disable RSpec/NestedGroups
        it "is time to go to bed (today's date)" do
          Timecop.travel(Time.zone.parse("May 12, 1938 05:00"))

          expect(described_class.today.to_s).to eq "1938-05-12"
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
        Timecop.return
      end

      it "defaults to today" do
        Timecop.travel(Time.zone.parse("Jan 1, 1928 19:00"))

        result = described_class.listing_dates(number_of_days: 1)

        expect(result).to eq(["1st January 1928".to_date])
      end
    end
  end
end

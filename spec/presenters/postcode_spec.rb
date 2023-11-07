# frozen_string_literal: true

require "spec_helper"
require "active_support"
require "active_support/core_ext/object/blank"
require "app/presenters/postcode"

RSpec.describe Postcode do
  describe ".build" do
    context "when the postcode was not empty" do
      describe "#short" do
        [
          { full: "E1 2JR", short: "E1" },
          { full: "N16 8QR", short: "N16" },
          { full: "SW9 0TH", short: "SW9" },
          { full: "SE14 6TA", short: "SE14" },
          { full: "WC1X 9HH", short: "WC1X" },
          { full: "EC2A 3AY", short: "EC2A" }
        ].each do |data|
          it "returns the first part of the postcode: #{data[:full]}" do # rubocop:disable RSpec/RepeatedExample
            expect(described_class.build(data[:full]).short).to eq data[:short]
          end
        end

        [
          { full: "E1", short: "E1" },
          { full: "N16", short: "N16" },
          { full: "SW9", short: "SW9" },
          { full: "SE14", short: "SE14" },
          { full: "WC1X", short: "WC1X" },
          { full: "EC2A", short: "EC2A" }
        ].each do |data|
          it "handles when only half the postcode is given: #{data[:full]}" do # rubocop:disable RSpec/RepeatedExample
            expect(described_class.build(data[:full]).short).to eq data[:short]
          end
        end

        [
          { full: "E12JR", short: "E1" },
          { full: "N168QR", short: "N16" },
          { full: "SW90TH", short: "SW9" },
          { full: "SE146TA", short: "SE14" },
          { full: "WC1X9HH", short: "WC1X" },
          { full: "EC2A3AY", short: "EC2A" }
        ].each do |data|
          it "handles postcodes without spaces: #{data[:full]}" do # rubocop:disable RSpec/RepeatedExample
            expect(described_class.build(data[:full]).short).to eq data[:short]
          end
        end

        [
          { full: "E1 2JR ", short: "E1" },
          { full: "N16  8QR", short: "N16" },
          { full: " SW90TH", short: "SW9" },
          { full: "SE14\t6TA", short: "SE14" }
        ].each do |data|
          it "handles postcodes with extra spaces: #{data[:full]}" do # rubocop:disable RSpec/RepeatedExample
            expect(described_class.build(data[:full]).short).to eq data[:short]
          end
        end

        [
          { full: "e1 2JR", short: "E1" },
          { full: "sw9 0Th", short: "SW9" },
          { full: "Se14 6TA", short: "SE14" }
        ].each do |data|
          it "upcases the result: #{data[:full]}" do # rubocop:disable RSpec/RepeatedExample
            expect(described_class.build(data[:full]).short).to eq data[:short]
          end
        end

        [
          "E12 JR",
          "E1 2 JR",
          "E",
          "NONSENSE"
        ].each do |string|
          context "when the string has weird formatting: #{string}" do
            it "raises an exception" do
              expect { described_class.build(string).short }
                .to raise_error("Couldn't parse #{string} as a postcode")
            end
          end
        end
      end

      describe "#description" do
        it "includes the full postcode" do
          presenter = described_class.build("N16 8QR")

          expect(presenter.description).to eq("N16 8QR to be precise. Click to see the venue on a map")
        end
      end
    end

    context "when the postcode was empty" do
      describe "#short" do
        it "is a secret" do
          presenter = described_class.build("")

          expect(presenter.short).to eq("???")
        end
      end

      describe "#description" do
        it "explains that it's a secret" do
          presenter = described_class.build("")

          expect(presenter.description).to eq("Bah - this event is too secret to have a postcode!")
        end
      end
    end
  end
end

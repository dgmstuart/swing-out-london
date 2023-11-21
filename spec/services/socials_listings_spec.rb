# frozen_string_literal: true

require "spec_helper"
require "app/services/socials_listings"
require "active_support"
require "active_support/core_ext/string/conversions"
require "active_support/core_ext/object/blank"

RSpec.describe SocialsListings do
  context "when there are several dates, and one event on one date" do
    it "returns an array with that event and date" do
      event = double("Event", id: 1, title: "Stompin", cancelled: false) # rubocop:disable RSpec/VerifiedDoubles
      event_finder = fake_event_finder("11 June 1935".to_date => [event])

      dates = ["10 June 1935", "11 June 1935", "12 June 1935"].map(&:to_date)
      result = described_class.new(event_finder:, presenter_class: test_presenter).build(dates)

      expect(result).to eq(
        [
          ["11 June 1935".to_date, [["Stompin", false]]]
        ]
      )
    end
  end

  context "when there are several dates, and one event on one date with a cancellation" do
    it "returns an array with that event and date and the event's id" do
      event = double("Event", id: 23, title: "Stompin", cancelled: true) # rubocop:disable RSpec/VerifiedDoubles
      event_finder = fake_event_finder("11 June 1935".to_date => [event])

      dates = ["10 June 1935", "11 June 1935", "12 June 1935"].map(&:to_date)
      result = described_class.new(event_finder:, presenter_class: test_presenter).build(dates)

      expect(result).to eq(
        [
          ["11 June 1935".to_date, [["Stompin", true]]]
        ]
      )
    end
  end

  context "when there are several events" do
    it "sorts them alphabetically in the output" do
      events = [
        double("Event", id: 1, title: "Boogaloo", cancelled: false), # rubocop:disable RSpec/VerifiedDoubles
        double("Event", id: 2, title: "Cotton Club", cancelled: false), # rubocop:disable RSpec/VerifiedDoubles
        double("Event", id: 3, title: "Alhambra", cancelled: false) # rubocop:disable RSpec/VerifiedDoubles
      ]
      event_finder = fake_event_finder("11 June 1935".to_date => events)

      dates = ["11 June 1935".to_date]
      result = described_class.new(event_finder:, presenter_class: test_presenter).build(dates)

      expect(result.first[1].map(&:first)).to eq(["Alhambra", "Boogaloo", "Cotton Club"])
    end
  end

  def fake_event_finder(results)
    double.tap do |event_finder|
      allow(event_finder).to receive(:call) do |date|
        results.fetch(date, [])
      end
    end
  end

  def fake_cancellation_finder(results)
    double.tap do |event_finder|
      allow(event_finder).to receive(:call) do |date|
        results.fetch(date, []).map(&:id)
      end
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

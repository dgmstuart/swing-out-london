# frozen_string_literal: true

require "spec_helper"
require "app/services/socials_listings"
require "active_support/core_ext/string/conversions"

RSpec.describe SocialsListings do
  context "when there are several dates, and one event on one date" do
    it "returns an array with that event and date" do
      event = instance_double("Event", title: "Stompin")
      event_finder = fake_event_finder("11 June 1935".to_date => [event])
      cancellation_finder = fake_cancellation_finder({})

      dates = ["10 June 1935", "11 June 1935", "12 June 1935"].map(&:to_date)
      result = described_class.new(event_finder:, cancellation_finder:, presenter_class: test_presenter).build(dates)

      expect(result).to eq(
        [
          ["11 June 1935".to_date, ["Stompin"], []]
        ]
      )
    end
  end

  context "when there are several dates, and one event on one date with a cancellation" do
    it "returns an array with that event and date and the event's id" do
      event = instance_double("Event", id: 23, title: "Stompin")
      event_finder = fake_event_finder("11 June 1935".to_date => [event])
      cancellation_finder = fake_cancellation_finder("11 June 1935".to_date => [event])

      dates = ["10 June 1935", "11 June 1935", "12 June 1935"].map(&:to_date)
      result = described_class.new(event_finder:, cancellation_finder:, presenter_class: test_presenter).build(dates)

      expect(result).to eq(
        [
          ["11 June 1935".to_date, ["Stompin"], [23]]
        ]
      )
    end
  end

  context "when there are several events" do
    it "sorts them alphabetically in the output" do
      events = [
        instance_double("Event", id: 1, title: "Boogaloo"),
        instance_double("Event", id: 2, title: "Cotton Club"),
        instance_double("Event", id: 3, title: "Alhambra")
      ]
      event_finder = fake_event_finder("11 June 1935".to_date => events)
      cancellation_finder = fake_cancellation_finder({})

      dates = ["11 June 1935".to_date]
      result = described_class.new(event_finder:, cancellation_finder:, presenter_class: test_presenter).build(dates)

      expect(result.first[1]).to eq(["Alhambra", "Boogaloo", "Cotton Club"])
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
    # instead of creating an instance, just print the event title
    Class.new do
      class << self
        def new(event)
          event.title
        end
      end
    end
  end
end

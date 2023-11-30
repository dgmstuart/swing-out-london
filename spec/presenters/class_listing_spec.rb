# frozen_string_literal: true

require "spec_helper"
require "active_support"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"
require "spec/support/time_formats_helper"
require "app/presenters/class_listing"

RSpec.describe ClassListing do
  describe "details" do
    context "when the event is a general/Lindy hop class" do
      it "includes the area" do
        event = instance_double("Event", venue_area: "Archway", class_style: nil, course_length: nil, started?: true)

        social_listing = described_class.new(event)

        expect(social_listing.details).to eq "Archway"
      end
    end

    context "when the event is a Balboa class" do
      it "includes the class style" do
        event = instance_double("Event", venue_area: "Archway", class_style: "Balboa", course_length: nil, started?: true)

        social_listing = described_class.new(event)

        expect(social_listing.details).to eq "Archway (Balboa)"
      end
    end

    context "when the event is a class which runs as courses" do
      it "includes the course length" do
        event = instance_double("Event", venue_area: "Archway", class_style: nil, course_length: 4, started?: true)

        social_listing = described_class.new(event)

        expect(social_listing.details).to eq "Archway - 4 week courses"
      end
    end

    context "when the event has not started yet" do
      it "includes the first date" do
        first_date = Date.parse("2023-07-14")
        event = instance_double("Event", venue_area: "Archway", class_style: nil, course_length: nil, started?: false, first_date:)

        social_listing = described_class.new(event)

        expect(social_listing.details).to eq "Archway (from 14th Jul)"
      end
    end

    context "when the event is complicated" do
      it "includes all the things" do
        first_date = Date.parse("2023-07-14")
        event = instance_double("Event", venue_area: "Archway", class_style: "Balboa", course_length: 6, started?: false, first_date:)

        social_listing = described_class.new(event)

        expect(social_listing.details).to eq "Archway (from 14th Jul) (Balboa) - 6 week courses"
      end
    end
  end

  describe "#url" do
    it "delegates to the given event" do
      event = instance_double("Event", url: "https://archwayslide.com")

      social_listing = described_class.new(event)

      expect(social_listing.url).to eq "https://archwayslide.com"
    end
  end

  describe "#title" do
    it "delegates to the given event" do
      event = instance_double("Event", title: "Archway Slide")

      social_listing = described_class.new(event)

      expect(social_listing.title).to eq "Archway Slide"
    end
  end

  describe "#day" do
    it "delegates to the given event" do
      event = instance_double("Event", day: "Wednesday")

      social_listing = described_class.new(event)

      expect(social_listing.day).to eq "Wednesday"
    end
  end

  describe "#class_organiser" do
    it "delegates to the given event" do
      event = instance_double("Event", class_organiser: "Ronnie Slide")

      social_listing = described_class.new(event)

      expect(social_listing.class_organiser).to eq "Ronnie Slide"
    end
  end

  describe "#has_social?" do
    it "delegates to the given event" do
      has_social = double
      event = instance_double("Event", has_social?: has_social)

      social_listing = described_class.new(event)

      expect(social_listing.has_social?).to eq has_social
    end
  end

  describe "#new?" do
    it "delegates to the given event" do
      new = double
      event = instance_double("Event", new?: new)

      social_listing = described_class.new(event)

      expect(social_listing.new?).to eq new
    end
  end

  describe "#future_cancellations" do
    it "delegates to the given event" do
      future_cancellations = double
      event = instance_double("Event", future_cancellations:)

      social_listing = described_class.new(event)

      expect(social_listing.future_cancellations).to eq future_cancellations
    end
  end

  describe "#venue" do
    it "delegates to the given event" do
      venue = double
      event = instance_double("Event", venue:)

      social_listing = described_class.new(event)

      expect(social_listing.venue).to eq venue
    end
  end

  describe "#venue_area" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_area: "Archway")

      social_listing = described_class.new(event)

      expect(social_listing.venue_area).to eq "Archway"
    end
  end

  describe "#venue_postcode" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_postcode: "N19 4DJ")

      social_listing = described_class.new(event)

      expect(social_listing.venue_postcode).to eq "N19 4DJ"
    end
  end
end

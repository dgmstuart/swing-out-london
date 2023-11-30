# frozen_string_literal: true

require "spec_helper"
require "active_support"
require "active_support/core_ext/module/delegation"
# require "active_support/core_ext/string/conversions"
require "app/presenters/class_listing"
# require "spec/support/time_formats_helper"

RSpec.describe ClassListing do
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

  describe "#class_style" do
    it "delegates to the given event" do
      event = instance_double("Event", class_style: "Balboa")

      social_listing = described_class.new(event)

      expect(social_listing.class_style).to eq "Balboa"
    end
  end

  describe "#course_length" do
    it "delegates to the given event" do
      event = instance_double("Event", course_length: 6)

      social_listing = described_class.new(event)

      expect(social_listing.course_length).to eq 6
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

  describe "#started?" do
    it "delegates to the given event" do
      started = double
      event = instance_double("Event", started?: started)

      social_listing = described_class.new(event)

      expect(social_listing.started?).to eq started
    end
  end

  describe "#first_date" do
    it "delegates to the given event" do
      event = instance_double("Event", first_date: Date.new)

      social_listing = described_class.new(event)

      expect(social_listing.first_date).to eq Date.new
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

# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/module/delegation"
require "app/presenters/social_listing"

RSpec.describe SocialListing do
  describe ".highlight?" do
    it "is true if the event is less frequent" do
      event = instance_double("Event", infrequent?: true)

      expect(described_class.new(event).highlight?).to be true
    end

    it "is false if the event is more frequent" do
      event = instance_double("Event", infrequent?: false)

      expect(described_class.new(event).highlight?).to be false
    end
  end

  describe ".id" do
    it "delegates to the given event" do
      event = instance_double("Event", id: 17)

      expect(described_class.new(event).id).to eq 17
    end
  end

  describe ".title" do
    it "delegates to the given event" do
      event = instance_double("Event", title: "Mambo Thursdays")

      expect(described_class.new(event).title).to eq "Mambo Thursdays"
    end
  end

  describe ".venue" do
    it "delegates to the given event" do
      venue = instance_double("Venue")
      event = instance_double("Event", venue:)

      expect(described_class.new(event).venue).to eq venue
    end
  end

  describe ".venue_id" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_id: 23)

      expect(described_class.new(event).venue_id).to eq 23
    end
  end

  describe ".venue_name" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_name: "100 Club")

      expect(described_class.new(event).venue_name).to eq "100 Club"
    end
  end

  describe ".venue_area" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_area: "Oxford st")

      expect(described_class.new(event).venue_area).to eq "Oxford st"
    end
  end

  describe ".url" do
    it "delegates to the given event" do
      event = instance_double("Event", url: "https://www.stompin.co.uk")

      expect(described_class.new(event).url).to eq "https://www.stompin.co.uk"
    end
  end

  describe ".new?" do
    it "delegates to the given event" do
      new = instance_double("Boolean")
      event = instance_double("Event", new?: new)

      expect(described_class.new(event).new?).to eq new
    end
  end

  describe ".has_class?" do
    it "delegates to the given event" do
      has_class = instance_double("Boolean")
      event = instance_double("Event", has_class?: has_class)

      expect(described_class.new(event).has_class?).to eq has_class
    end
  end

  describe ".has_taster?" do
    it "delegates to the given event" do
      has_taster = instance_double("Boolean")
      event = instance_double("Event", has_taster?: has_taster)

      expect(described_class.new(event).has_taster?).to eq has_taster
    end
  end

  describe ".class_style" do
    it "delegates to the given event" do
      event = instance_double("Event", class_style: "Balboa")

      expect(described_class.new(event).class_style).to eq "Balboa"
    end
  end

  describe ".class_organiser" do
    it "delegates to the given event" do
      event = instance_double("Event", class_organiser: "Frankie Manning")

      expect(described_class.new(event).class_organiser).to eq "Frankie Manning"
    end
  end
end

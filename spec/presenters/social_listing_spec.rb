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

  describe ".cancelled?" do
    it "is true if the given value is true" do
      event = instance_double("Event")

      expect(described_class.new(event, cancelled: true).cancelled?).to be true
    end

    it "is false if the given value is false" do
      event = instance_double("Event")

      expect(described_class.new(event, cancelled: false).cancelled?).to be false
    end

    it "defaults to false" do
      event = instance_double("Event")

      expect(described_class.new(event).cancelled?).to be false
    end
  end

  describe ".location" do
    it "is the combination venue name and location" do
      event = instance_double("Event", venue_name: "The Savoy Ballroom", venue_area: "Harlem")

      expect(described_class.new(event).location).to eq "The Savoy Ballroom in Harlem"
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

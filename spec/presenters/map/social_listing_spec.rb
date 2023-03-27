# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/module/delegation"
require "app/presenters/social_listing"
require "app/presenters/map/social_listing"

RSpec.describe Map::SocialListing do
  describe ".has_class?" do
    it "delegates to the given event" do
      has_class = instance_double("Boolean")
      event = instance_double("Event", has_class?: has_class)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.has_class?).to eq has_class
    end
  end

  describe ".has_taster?" do
    it "delegates to the given event" do
      has_taster = instance_double("Boolean")
      event = instance_double("Event", has_taster?: has_taster)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.has_taster?).to eq has_taster
    end
  end

  describe ".class_style" do
    it "delegates to the given event" do
      event = instance_double("Event", class_style: "Balboa")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.class_style).to eq "Balboa"
    end
  end

  describe ".class_organiser" do
    it "delegates to the given event" do
      event = instance_double("Event", class_organiser: "Frankie Manning")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.class_organiser).to eq "Frankie Manning"
    end
  end
end

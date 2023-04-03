# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/conversions"
require "app/presenters/social_listing"
require "spec/support/time_formats_helper"

RSpec.describe SocialListing do
  describe ".highlight?" do
    it "is true if the event is less frequent" do
      event = instance_double("Event", infrequent?: true)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.highlight?).to be true
    end

    it "is false if the event is more frequent" do
      event = instance_double("Event", infrequent?: false)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.highlight?).to be false
    end
  end

  describe ".cancelled?" do
    it "is true if the given value is true" do
      event = instance_double("Event")

      social_listing = described_class.new(event, cancelled: true, url_helpers: double)

      expect(social_listing.cancelled?).to be true
    end

    it "is false if the given value is false" do
      event = instance_double("Event")

      social_listing = described_class.new(event, cancelled: false, url_helpers: double)

      expect(social_listing.cancelled?).to be false
    end

    it "defaults to false" do
      event = instance_double("Event")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.cancelled?).to be false
    end
  end

  describe ".location" do
    it "is the combination venue name and location" do
      event = instance_double("Event", venue_name: "The Savoy Ballroom", venue_area: "Harlem")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.location).to eq "The Savoy Ballroom in Harlem"
    end
  end

  describe ".map_url" do
    context "when the venue has no coordinates" do
      it "is nil" do
        event = instance_double("Event", venue_coordinates: nil)

        social_listing = described_class.new(event, url_helpers: double)

        expect(social_listing.map_url(Date.current)).to be_nil
      end
    end

    context "when the venue has coordinates" do
      it "is a link to the venue on the map" do
        event = instance_double("Event", venue_id: 5, venue_coordinates: double)
        url_helpers = double(map_socials_path: "a-map-url") # rubocop:disable RSpec/VerifiedDoubles

        social_listing = described_class.new(event, url_helpers:)

        aggregate_failures do
          expect(social_listing.map_url("11 July 1936".to_date)).to eq("a-map-url")
          expect(url_helpers).to have_received(:map_socials_path)
            .with(date: "1936-07-11", venue_id: 5)
        end
      end
    end
  end

  describe ".id" do
    it "delegates to the given event" do
      event = instance_double("Event", id: 17)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.id).to eq 17
    end
  end

  describe ".title" do
    it "delegates to the given event" do
      event = instance_double("Event", title: "Mambo Thursdays")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.title).to eq "Mambo Thursdays"
    end
  end

  describe ".venue_postcode" do
    it "delegates to the given event" do
      event = instance_double("Event", venue_postcode: "N1 3QA")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.venue_postcode).to eq "N1 3QA"
    end
  end

  describe ".url" do
    it "delegates to the given event" do
      event = instance_double("Event", url: "https://www.stompin.co.uk")

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.url).to eq "https://www.stompin.co.uk"
    end
  end

  describe ".new?" do
    it "delegates to the given event" do
      new = instance_double("Boolean")
      event = instance_double("Event", new?: new)

      social_listing = described_class.new(event, url_helpers: double)

      expect(social_listing.new?).to eq new
    end
  end
end

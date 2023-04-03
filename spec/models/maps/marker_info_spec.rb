# frozen_string_literal: true

require "spec_helper"
require "support/time_formats_helper"
require "active_support/core_ext/module/delegation"
require "app/models/maps/marker_info"

RSpec.describe Maps::MarkerInfo do
  describe "#venue_name" do
    it "delegates to the venue" do
      venue = instance_double("Venue", name: "Café Lounge")

      marker_info = described_class.new(venue:, events: double)

      expect(marker_info.venue_name).to eq("Café Lounge")
    end
  end

  describe "#venue_url" do
    it "delegates to the venue" do
      venue = instance_double("Venue", website: "https://lounge.com")

      marker_info = described_class.new(venue:, events: double)

      expect(marker_info.venue_url).to eq("https://lounge.com")
    end
  end

  describe "#address_lines" do
    it "is the venue address as an array of lines" do
      venue = instance_double("Venue", address: "77 Bedford Hill, Balham")

      marker_info = described_class.new(venue:, events: double)

      expect(marker_info.address_lines).to eq(["77 Bedford Hill", "Balham"])
    end

    it 'removes "London" from the address lines' do
      venue = instance_double("Venue", address: "1 Chancery Court, London")

      marker_info = described_class.new(venue:, events: double)

      expect(marker_info.address_lines).to eq(["1 Chancery Court"])
    end
  end

  describe "#postcode" do
    it "delegates to the venue" do
      venue = instance_double("Venue", postcode: "CA4 3LN")

      marker_info = described_class.new(venue:, events: double)

      expect(marker_info.postcode).to eq("CA4 3LN")
    end
  end

  describe "social_listings_rows.date" do
    it "returns the date of the social" do
      event = instance_double("SocialListing")
      event_listing_data = [Date.new(1934, 1, 4), [event]]

      marker_info = described_class.new(venue: double, events: [event_listing_data])

      expect(marker_info.social_listings_rows.first.date).to eq("Thursday 4th January")
    end
  end

  describe "social_listings_rows.social_listing" do
    it "returns true" do
      event = instance_double("SocialListing")
      event_listing_data = [double, [event]]

      marker_info = described_class.new(venue: double, events: [event_listing_data])

      expect(marker_info.social_listings_rows.first.social_listing).to eq(event)
    end
  end

  describe "class_listings.day" do
    it "returns the date of the social" do
      event = instance_double("Event", day: "Wednesday")

      marker_info = described_class.new(venue: double, events: [event])

      expect(marker_info.class_listings.first.day).to eq("Wednesdays")
    end
  end
end

# frozen_string_literal: true

require "spec_helper"
require "support/time_formats_helper"
require "active_support/core_ext/module/delegation"
require "app/presenters/maps/marker/venue"

RSpec.describe Maps::Marker::Venue do
  describe "#name" do
    it "delegates to the venue" do
      venue = instance_double("Venue", name: "Café Lounge")

      marker_info = described_class.new(venue)

      expect(marker_info.name).to eq("Café Lounge")
    end
  end

  describe "#url" do
    it "delegates to the venue" do
      venue = instance_double("Venue", website: "https://lounge.com")

      marker_info = described_class.new(venue)

      expect(marker_info.url).to eq("https://lounge.com")
    end
  end

  describe "#address_lines" do
    it "is the venue address as an array of lines" do
      venue = instance_double("Venue", address: "77 Bedford Hill, Balham")

      marker_info = described_class.new(venue)

      expect(marker_info.address_lines).to eq(["77 Bedford Hill", "Balham"])
    end

    it 'removes "London" from the address lines' do
      venue = instance_double("Venue", address: "1 Chancery Court, London")

      marker_info = described_class.new(venue)

      expect(marker_info.address_lines).to eq(["1 Chancery Court"])
    end
  end

  describe "#postcode" do
    it "delegates to the venue" do
      venue = instance_double("Venue", postcode: "CA4 3LN")

      marker_info = described_class.new(venue)

      expect(marker_info.postcode).to eq("CA4 3LN")
    end
  end
end

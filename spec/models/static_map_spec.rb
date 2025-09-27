# frozen_string_literal: true

require "spec_helper"
require "app/models/static_map"
require "active_support/core_ext/object/to_query"

RSpec.describe StaticMap do
  describe "#url" do
    it "is a URL for Google's static map API" do
      map = described_class.new(
        lat: 51.5424192,
        lng: -0.0773055,
        width: 400,
        height: 300,
        api_key: "A1B2C3",
        map_id: "X9y8Z7"
      )

      expect(map.url).to eq(
        "https://maps.googleapis.com/maps/api/staticmap?" \
        "center=51.5424192%2C-0.0773055" \
        "&key=A1B2C3" \
        "&map_id=X9y8Z7" \
        "&maptype=roadmap" \
        "&markers=51.5424192%2C-0.0773055" \
        "&size=400x300&zoom=17"
      )
    end

    context "when the key hasn't been set" do
      it "is nil" do
        map = described_class.new(
          lat: 51.5424192,
          lng: -0.0773055,
          width: 400,
          height: 300,
          api_key: nil
        )

        expect(map.url).to be_nil
      end
    end
  end

  describe ".from_venue#url" do
    it "is a URL for Google's static map API" do
      venue = instance_double(
        "Venue",
        lat: 51.5424192,
        lng: -0.0773055
      )
      map = described_class.from_venue(
        venue:,
        width: 400,
        height: 300,
        api_key: "A1B2C3"
      )

      expect(map.url).to eq(
        "https://maps.googleapis.com/maps/api/staticmap?" \
        "center=51.5424192%2C-0.0773055" \
        "&key=A1B2C3" \
        "&maptype=roadmap" \
        "&markers=51.5424192%2C-0.0773055" \
        "&size=400x300&zoom=17"
      )
    end
  end
end

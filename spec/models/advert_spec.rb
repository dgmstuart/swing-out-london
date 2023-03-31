# frozen_string_literal: true

require "spec_helper"
require "app/models/advert"

RSpec.describe Advert do
  describe ".current" do
    it "builds an Advert object based on environment variables" do
      env = {
        "ADVERT_ENABLED" => "true",
        "ADVERT_URL" => "https://myevent.co.uk",
        "ADVERT_IMAGE_URL" => "https://myevent.co.uk/banner",
        "ADVERT_TITLE" => "My Event",
        "ADVERT_GOOGLE_ID" => "me-1"
      }

      advert = described_class.current(env:)

      aggregate_failures do
        expect(advert.url).to eq "https://myevent.co.uk"
        expect(advert.image_url).to eq "https://myevent.co.uk/banner"
        expect(advert.title).to eq "My Event"
        expect(advert.google_id).to eq "me-1"
      end
    end

    context "when the advert is disabled" do
      it "returns nil" do
        env = {
          "ADVERT_ENABLED" => "false",
          "ADVERT_URL" => "https://myevent.co.uk",
          "ADVERT_IMAGE_URL" => "https://myevent.co.uk/banner",
          "ADVERT_TITLE" => "My Event",
          "ADVERT_GOOGLE_ID" => "me-1"
        }

        advert = described_class.current(env:)

        expect(advert).to be_nil
      end
    end
  end
end

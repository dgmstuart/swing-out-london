# frozen_string_literal: true

require "rails_helper"
require "app/helpers/venues_helper"

RSpec.describe VenuesHelper do
  describe "google_maps_url" do
    it "renders a link to a map marker" do
      expect(helper.google_maps_url(51.5, -0.1, 10))
        .to eq("https://www.google.co.uk/maps/place/51.5,-0.1/@51.5,-0.1,10z")
    end
  end
end

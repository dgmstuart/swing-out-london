# frozen_string_literal: true

require "rails_helper"

RSpec.describe "robots.txt" do
  context "with a canonical host" do
    around do |example|
      ClimateControl.modify(CANONICAL_HOST: "www.swingoutlondon.co.uk") { example.run }
    end

    it "blocks robots from /login" do
      get "/robots.txt"
      expect(response.body).to include "Disallow: /login"
    end

    it "includes a link to the sitemap" do
      get "/robots.txt"
      expect(response.body).to include "Sitemap: https://www.swingoutlondon.co.uk"
    end

    it "returns the correct file type" do
      get "/robots.txt"
      expect(response.headers["Content-Type"]).to include "text/plain"
    end

    it "can be publicly cached" do
      get "/robots.txt"
      expect(response.headers["Cache-Control"]).to include "public"
    end

    it "can be cached for 6 hours" do
      get "/robots.txt"
      expect(response.headers["Cache-Control"]).to include "max-age=21600" # 6 hours in seconds
    end
  end

  context "without a canonical host" do
    around do |example|
      ClimateControl.modify(CANONICAL_HOST: nil) { example.run }
    end

    it "still returns a file" do
      get "/robots.txt"
      expect(response.body).to include "Disallow: /login"
    end
  end
end

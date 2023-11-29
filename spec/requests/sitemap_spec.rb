# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sitemaps" do
  around do |example|
    ClimateControl.modify(CANONICAL_HOST: "www.swingoutlondon.co.uk") { example.run }
  end

  it "renders an xml sitemap" do
    get "/sitemap.xml"

    expected_sitemap = File.read(fixture_file("sitemap.xml"))

    expect(response.body).to eq(expected_sitemap)
  end

  it "defaults to xml" do
    get "/sitemap"

    expect(response).to have_http_status(:ok)
  end

  it "redirects requests for sitemap_index" do
    get "/sitemap_index.xml"

    aggregate_failures do
      expect(response).to redirect_to("/sitemap.xml")
      expect(response).to have_http_status(:moved_permanently)
    end
  end

  it "redirects requests for sitemap.xml.gz" do
    get "/sitemap.xml.gz"

    aggregate_failures do
      expect(response).to redirect_to("/sitemap.xml")
      expect(response).to have_http_status(:moved_permanently)
    end
  end

  it "doesn't respond to other formats" do
    get "/sitemap.txt"

    expect(response).to have_http_status(:not_found)
  end

  def fixture_file(filename)
    Rails.root.join("spec", "fixtures", filename)
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Undefined assets" do
  %w[
    apple-touch-icon-precomposed.png
    apple-touch-icon-120x120-precomposed.png
    apple-app-site-association.png
  ].each do |asset_name|
    it "returns an empty 404 for requests for #{asset_name}" do
      get "/#{asset_name}"

      aggregate_failures do
        expect(response).to have_http_status(:not_found)
        expect(response.media_type).to eq("text/plain")
      end
    end
  end
end

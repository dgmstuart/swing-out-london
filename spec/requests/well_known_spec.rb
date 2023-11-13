# frozen_string_literal: true

require "rails_helper"

RSpec.describe ".well-known/" do
  it "returns 204 for requests to /.well-known/traffic-advice" do
    get "/.well-known/traffic-advice"

    aggregate_failures do
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end
  end

  it "returns 204 for requests to /.well-known/" do
    get "/.well-known/"

    aggregate_failures do
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end
  end

  it "returns an empty json object for requests to /.well-known/apple-app-site-association" do
    get "/.well-known/apple-app-site-association"

    aggregate_failures do
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq "{}"
      expect(response.headers).to match(a_hash_including("Content-Type" => a_string_matching("application/json")))
    end
  end
end

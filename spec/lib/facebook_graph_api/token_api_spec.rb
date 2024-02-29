# frozen_string_literal: true

require "spec_helper"
require "lib/facebook_graph_api/token_api"

RSpec.describe FacebookGraphApi::TokenApi do
  describe "#exchange_token" do
    it "makes an API request to exchange an auth token for a new long-lived auth token" do # rubocop:disable RSpec/ExampleLength
      http_client = instance_double("HTTP::Chainable", get: double)
      api = described_class.new(
        base_url: "https://example.com",
        http_client:,
        client_id: 123456,
        client_secret: "super-secret"
      )

      api.exchange_token("an-auth-token")

      expect(http_client).to have_received(:get).with(
        "https://example.com/oauth/access_token",
        params: {
          grant_type: "fb_exchange_token",
          client_id: 123456,
          client_secret: "super-secret",
          fb_exchange_token: "an-auth-token"
        }
      )
    end
  end
end

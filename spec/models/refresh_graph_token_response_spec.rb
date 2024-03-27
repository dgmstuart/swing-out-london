# frozen_string_literal: true

require "spec_helper"
require "app/models/refresh_graph_token_response"

RSpec.describe RefreshGraphTokenResponse do
  describe "#token" do
    it "returns the token from the response body" do
      response_body = '{"access_token":"super-secret-token","token_type":"bearer","expires_in":5183785}'

      response = described_class.new(response_body, now_in_seconds: double)

      expect(response.token).to eq "super-secret-token"
    end
  end

  describe "#token_expires_at" do
    it "returns the approximate time that the token will expire" do
      response_body = '{"access_token":"super-secret-token","token_type":"bearer","expires_in":200}'

      response = described_class.new(response_body, now_in_seconds: 1000)

      expect(response.token_expires_at).to eq 1200
    end
  end
end

# frozen_string_literal: true

require "spec_helper"
require "lib/slack/http_client"
require "active_support/hash_with_indifferent_access"

RSpec.describe Slack::HttpClient do
  describe "#delete" do
    it "makes an http request" do
      json = "{}"
      stub_request(:delete, "https://example.com/path")
        .to_return(body: json)

      client = described_class.new(
        base_url: "https://example.com",
        auth_token: "super-secret-token"
      )
      client.delete("/path")

      expect(
        a_request(:delete, "https://example.com/path")
        .with(headers: { "Authorization" => "Bearer super-secret-token" })
      ).to have_been_made
    end

    it "returns the response body with symbol keys" do
      json = '{"ok":true,"revoked":true}'
      stub_request(:delete, "https://example.com/path")
        .to_return(body: json)

      client = described_class.new(
        base_url: "https://example.com",
        auth_token: "super-secret-token"
      )
      result = client.delete("/path")

      expect(result).to eq({ ok: true, revoked: true })
    end
  end
end

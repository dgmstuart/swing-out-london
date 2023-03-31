# frozen_string_literal: true

require "spec_helper"
require "lib/facebook_graph_api/http_client"

RSpec.describe FacebookGraphApi::HttpClient do
  describe "#delete" do
    it "makes an http request" do
      stub_request(:delete, "https://example.com/path")
        .with(query: { appsecret_proof: "app-secret-proof-token" })
      proof_generator = instance_double("FacebookGraphApi::AppsecretProofGenerator")
      allow(proof_generator).to receive(:generate)
        .with("super-secret-token")
        .and_return("app-secret-proof-token")

      client = described_class.new(
        base_url: "https://example.com/",
        auth_token: "super-secret-token",
        proof_generator:
      )
      client.delete("/path")

      expect(
        a_request(:delete, "https://example.com/path")
        .with(
          headers: { "Authorization" => "Bearer super-secret-token" },
          query: { appsecret_proof: "app-secret-proof-token" }
        )
      ).to have_been_made
    end

    context "when the response was not successful" do
      it "raises an error" do
        error_json = {
          error: {
            message: "An access token is required to request this resource.",
            type: "OAuthException",
            code: 104,
            fbtrace_id: "HZNbuD4fi8u"
          }
        }.to_json
        stub_request(:delete, "https://example.com/path")
          .with(query: { appsecret_proof: "app-secret-proof-token" })
          .to_return(status: 400, body: error_json)
        proof_generator = instance_double("FacebookGraphApi::AppsecretProofGenerator",
                                          generate: "app-secret-proof-token")

        client = described_class.new(
          base_url: "https://example.com/",
          auth_token: "super-secret-token",
          proof_generator:
        )

        expect { client.delete("/path") }
          .to raise_error(
            described_class::ResponseError,
            "OAuthException (code: 104) An access token is required to request this resource."
          )
      end
    end
  end
end

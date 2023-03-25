# frozen_string_literal: true

require "spec_helper"
require "facebook_graph_api/appsecret_proof_generator"

RSpec.describe FacebookGraphApi::AppsecretProofGenerator do
  describe "#generate" do
    it "generates a proof token based on the app secret and auth token" do
      digest = instance_double(OpenSSL::Digest::SHA256)
      allow(OpenSSL::Digest).to receive(:new).with("SHA256").and_return(digest)
      allow(OpenSSL::HMAC).to receive(:hexdigest)

      described_class.new(app_secret: "app-secret").generate("auth-token")

      expect(OpenSSL::HMAC).to have_received(:hexdigest)
        .with(digest, "app-secret", "auth-token")
    end

    it "returns the generated proof token" do
      token = double
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return(token)

      generator = described_class.new(app_secret: "app-secret")

      expect(generator.generate("auth-token")).to eq token
    end
  end
end

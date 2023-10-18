# frozen_string_literal: true

require "spec_helper"
require "lib/slack/api"

RSpec.describe Slack::Api do
  describe "#revoke_login" do
    it "makes a request to revoke the user's login" do
      http_client = instance_double("HTTP::Client", delete: { ok: true, revoked: true })

      described_class.new(http_client, logger: double).revoke_login

      expect(http_client).to have_received(:delete).with("/auth.revoke")
    end

    context "when the response was OK" do
      it "returns true" do
        http_client = instance_double("HTTP::Client", delete: { ok: true, revoked: true })

        result = described_class.new(http_client, logger: double).revoke_login

        expect(result).to be true
      end
    end

    context "when the response was not OK, but the token was already revoked" do
      it "returns true" do
        http_client = instance_double("HTTP::Client", delete: { ok: false, error: "token_revoked" })

        result = described_class.new(http_client, logger: double).revoke_login

        expect(result).to be true
      end
    end

    context "when the response was an error" do
      it "logs and returns false" do
        http_client = instance_double("HTTP::Client", delete: { ok: false, error: "invalid_auth" })
        logger = instance_double("Logger", error: true)

        result = described_class.new(http_client, logger:).revoke_login

        aggregate_failures do
          expect(logger).to have_received(:error).with "Auth revocation failed: invalid_auth"
          expect(result).to be false
        end
      end
    end
  end
end

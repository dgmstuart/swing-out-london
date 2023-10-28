# frozen_string_literal: true

require "spec_helper"
require "lib/facebook_graph_api/api"

RSpec.describe FacebookGraphApi::Api do
  describe "#revoke_login" do
    it "makes a request to revoke the user's login" do
      http_client = instance_double("FacebookGraphApi::HttpClient", delete: double)

      described_class.new(http_client).revoke_login("1234567")

      expect(http_client).to have_received(:delete).with("/1234567/permissions")
    end

    context "when the user id is nil" do
      it "raises an error" do
        api = described_class.new(double)

        expect { api.revoke_login(nil) }
          .to raise_error(ArgumentError, "missing user id")
      end
    end
  end

  describe "#profile" do
    it "makes a request to fetch the identified profile" do
      http_client = instance_double("FacebookGraphApi::HttpClient", get: double)

      described_class.new(http_client).profile("1234567")

      expect(http_client).to have_received(:get).with("/1234567")
    end

    it "returns whatever it gets in response" do
      response = double
      http_client = instance_double("FacebookGraphApi::HttpClient", get: response)

      result = described_class.new(http_client).profile("1234567")

      expect(result).to eq response
    end

    context "when the user id is nil" do
      it "raises an error" do
        api = described_class.new(double)

        expect { api.profile(nil) }
          .to raise_error(ArgumentError, "missing user id")
      end
    end
  end
end

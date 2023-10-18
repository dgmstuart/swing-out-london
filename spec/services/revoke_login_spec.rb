# frozen_string_literal: true

require "spec_helper"
require "app/services/revoke_login"

RSpec.describe RevokeLogin do
  describe "#revoke!" do
    it "builds an API client based on the user" do
      http_client = instance_double("Slack::HttpClient")
      http_client_builder = class_double("Slack::HttpClient", new: http_client)
      api = instance_double("Slack::Api", revoke_login: double)
      api_builder = class_double("Slack::Api", new: api)
      logger = instance_double("Logger", info: true)
      auth_token = double
      user = instance_double("LoginSession::User", token: auth_token, auth_id: double)

      service = described_class.new(http_client_builder:, api_builder:, logger:)
      service.revoke!(user)

      aggregate_failures do
        expect(http_client_builder).to have_received(:new).with(auth_token:)
        expect(api_builder).to have_received(:new).with(http_client)
      end
    end

    it "makes an API call to revoke the token" do
      http_client_builder = class_double("Slack::HttpClient", new: double)
      api = instance_double("Slack::Api", revoke_login: double)
      api_builder = class_double("Slack::Api", new: api)
      logger = instance_double("Logger", info: true)
      user = instance_double("LoginSession::User", token: double, auth_id: double)

      service = described_class.new(http_client_builder:, api_builder:, logger:)
      service.revoke!(user)

      expect(api).to have_received(:revoke_login)
    end

    it "logs that the user revoked their permissions" do
      http_client_builder = class_double("Slack::HttpClient", new: double)
      api = instance_double("Slack::Api", revoke_login: double)
      api_builder = class_double("Slack::Api", new: api)
      logger = instance_double("Logger", info: true)
      user = instance_double("LoginSession::User", token: double, auth_id: 12345678901234567)

      service = described_class.new(http_client_builder:, api_builder:, logger:)
      service.revoke!(user)

      expect(logger).to have_received(:info)
        .with("Auth id 12345678901234567 revoked their login permissions")
    end

    it "returns the return value of the API call" do
      response = double
      http_client_builder = class_double("Slack::HttpClient", new: double)
      api = instance_double("Slack::Api", revoke_login: response)
      api_builder = class_double("Slack::Api", new: api)
      logger = instance_double("Logger", info: true)
      user = instance_double("LoginSession::User", token: double, auth_id: 12345678901234567)

      service = described_class.new(http_client_builder:, api_builder:, logger:)
      result = service.revoke!(user)

      expect(result).to eq response
    end
  end
end

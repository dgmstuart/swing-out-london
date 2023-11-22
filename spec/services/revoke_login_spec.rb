# frozen_string_literal: true

require "spec_helper"
require "app/services/revoke_login"

RSpec.describe RevokeLogin do
  describe "#revoke!" do
    it "builds an API client based on the user" do
      api = instance_double("FacebookGraphApi::UserApi", revoke_login: double)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      logger = instance_double("Logger", info: true)
      auth_token = double
      user = instance_double("LoginSession::User", token: auth_token, auth_id: double)

      service = described_class.new(api_builder:, logger:)
      service.revoke!(user)

      expect(api_builder).to have_received(:for_user).with(user)
    end

    it "makes a call to the Facebook API" do
      api = instance_double("FacebookGraphApi::UserApi", revoke_login: double)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      logger = instance_double("Logger", info: true)
      auth_id = double
      user = instance_double("LoginSession::User", token: double, auth_id:)

      service = described_class.new(api_builder:, logger:)
      service.revoke!(user)

      expect(api).to have_received(:revoke_login)
    end

    it "logs that the user revoked their permissions" do
      api = instance_double("FacebookGraphApi::UserApi", revoke_login: double)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      logger = instance_double("Logger", info: true)
      user = instance_double("LoginSession::User", token: double, auth_id: 12345678901234567)

      service = described_class.new(api_builder:, logger:)
      service.revoke!(user)

      expect(logger).to have_received(:info)
        .with("Auth id 12345678901234567 revoked their login permissions")
    end
  end
end

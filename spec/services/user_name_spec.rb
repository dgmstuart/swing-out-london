# frozen_string_literal: true

require "spec_helper"
require "app/services/user_name"

RSpec.describe UserName do
  describe "#name_for" do
    it "builds an API client based on the user" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:)
      service.name_for(double)

      expect(api_builder).to have_received(:for_user).with(user)
    end

    it "makes a call to the Facebook API" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:)
      service.name_for(123456)

      expect(api).to have_received(:profile).with(123456)
    end

    it "returns the name of the specified user" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:)
      result = service.name_for(123456)

      expect(result).to eq "Willamae Ricker"
    end
  end
end

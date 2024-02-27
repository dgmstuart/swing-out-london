# frozen_string_literal: true

require "spec_helper"
require "app/services/user_name"
require "facebook_graph_api/http_client" # for the ResponseError class

RSpec.describe UserName do
  describe "#name_for" do
    it "builds an API client based on the user" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:, error_reporter: double)
      service.name_for(double)

      expect(api_builder).to have_received(:for_user).with(user)
    end

    it "makes a call to the Facebook API" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:, error_reporter: double)
      service.name_for(123456)

      expect(api).to have_received(:profile).with(123456)
    end

    it "returns the name of the specified user" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::UserApi", profile:)
      api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
      user = instance_double("LoginSession::User")

      service = described_class.new(api_builder:, user:, error_reporter: double)
      result = service.name_for(123456)

      expect(result).to eq "Willamae Ricker"
    end

    context "when the user name couldn't be retrieved" do
      it "returns an unknown value" do # rubocop:disable RSpec/ExampleLength
        api = instance_double("FacebookGraphApi::UserApi")
        allow(api).to receive(:profile).and_raise(
          FacebookGraphApi::HttpClient::ResponseError,
          "Unsupported get request. Object with ID '123456' does not exist..."
        )
        api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
        error_reporter = class_double("Rollbar", error: double)
        user = instance_double("LoginSession::User")

        service = described_class.new(api_builder:, user:, error_reporter:)
        result = service.name_for(123456)

        expect(result).to eq "[Unknown user]"
      end

      it "reports the error" do # rubocop:disable RSpec/ExampleLength
        api = instance_double("FacebookGraphApi::UserApi")
        allow(api).to receive(:profile).and_raise(
          FacebookGraphApi::HttpClient::ResponseError,
          "Unsupported get request. Object with ID '123456' does not exist..."
        )
        api_builder = class_double("FacebookGraphApi::UserApi", for_user: api)
        error_reporter = class_double("Rollbar", error: double)
        user = instance_double("LoginSession::User")

        service = described_class.new(api_builder:, user:, error_reporter:)
        service.name_for(123456)

        expect(error_reporter).to have_received(:error).with(
          an_instance_of(FacebookGraphApi::HttpClient::ResponseError)
            .and(have_attributes(message: "Unsupported get request. Object with ID '123456' does not exist..."))
        )
      end
    end
  end
end

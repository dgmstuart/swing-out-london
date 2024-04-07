# frozen_string_literal: true

require "spec_helper"
require "app/services/user_name"
require "active_support"
require "active_support/cache"
require "active_support/core_ext/integer/time"
require "facebook_graph_api/http_client" # for the ResponseError class

RSpec.describe UserName do
  before do
    cache = ActiveSupport::Cache::NullStore.new
    stub_const("Rails", class_double("Rails", cache:))
  end

  describe ".as_user" do
    it "builds an API client based on the user" do
      stub_const("Rollbar", double)
      user = instance_double("LoginSession::User", token: "abc987")
      allow(FacebookGraphApi::Api).to receive(:for_token)

      described_class.as_user(user)

      expect(FacebookGraphApi::Api).to have_received(:for_token).with("abc987")
    end
  end

  describe "#name_for" do
    it "makes a call to the Facebook API" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::Api", profile:)

      service = described_class.new(api:, error_reporter: double)
      service.name_for(123456)

      expect(api).to have_received(:profile).with(123456)
    end

    it "returns the name of the specified user" do
      profile = { "name" => "Willamae Ricker", "id" => 123456 }
      api = instance_double("FacebookGraphApi::Api", profile:)

      service = described_class.new(api:, error_reporter: double)
      result = service.name_for(123456)

      expect(result).to eq "Willamae Ricker"
    end

    context "when the user name couldn't be retrieved" do
      it "returns an unknown value" do
        api = instance_double("FacebookGraphApi::Api")
        allow(api).to receive(:profile).and_raise(
          FacebookGraphApi::HttpClient::ResponseError,
          "Unsupported get request. Object with ID '123456' does not exist..."
        )
        error_reporter = class_double("Rollbar", error: double)

        service = described_class.new(api:, error_reporter:)
        result = service.name_for(123456)

        expect(result).to eq "[Unknown user]"
      end

      it "reports the error" do
        api = instance_double("FacebookGraphApi::Api")
        allow(api).to receive(:profile).and_raise(
          FacebookGraphApi::HttpClient::ResponseError,
          "Unsupported get request. Object with ID '123456' does not exist..."
        )
        error_reporter = class_double("Rollbar", error: double)

        service = described_class.new(api:, error_reporter:)
        service.name_for(123456)

        expect(error_reporter).to have_received(:error).with(
          an_instance_of(FacebookGraphApi::HttpClient::ResponseError)
            .and(have_attributes(message: "Unsupported get request. Object with ID '123456' does not exist..."))
        )
      end
    end
  end
end

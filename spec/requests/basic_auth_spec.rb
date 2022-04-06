# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Basic Auth" do
  context "when not enabled" do
    it "pages can be visited with no auth" do
      get("/")

      expect(response).to have_http_status(:ok)
    end
  end

  context "when enabled" do
    it "allows access if the right credentials are passed" do
      ClimateControl.modify(BASIC_AUTH_USER: "user", BASIC_AUTH_PASSWORD: "pass") do
        headers = { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials("user", "pass") }

        get("/", headers:)

        expect(response).to have_http_status(:ok)
      end
    end

    it "disallows access if the right credentials are passed" do
      ClimateControl.modify(BASIC_AUTH_USER: "user", BASIC_AUTH_PASSWORD: "pass") do
        headers = { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials("user", "wrong-pass") }

        get("/", headers:)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context "when values are present but empty" do
    it "behaves as not enabled" do
      ClimateControl.modify(BASIC_AUTH_USER: "user", BASIC_AUTH_PASSWORD: "") do
        headers = { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials("user", "wrong-pass") }

        get("/", headers:)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end

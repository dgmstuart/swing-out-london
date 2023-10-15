# frozen_string_literal: true

require "rails_helper"
require "lib/omniauth_test_response_builder"

RSpec.describe OmniauthTestResponseBuilder do
  describe "#stub_auth_hash" do
    it "configures Omniauth to return a fixed hash from all requests" do
      auth_hash = instance_double("OmniAuth::AuthHash")
      hash_builder = class_double("OmniAuth::AuthHash", new: auth_hash)
      mock_auth_config = {}

      described_class.new(hash_builder:, mock_auth_config:).stub_auth_hash
      expect(mock_auth_config).to eq(auth0: auth_hash)
    end

    it "builds an auth hash based on the provided data" do
      hash_builder = class_double("OmniAuth::AuthHash", new: double)
      mock_auth_config = {}

      described_class.new(hash_builder:, mock_auth_config:).stub_auth_hash(
        email: "lkertz@example.com",
        name: "Lauretta Kertzmann",
        token: "237699305323155|dc16f036399dda7bc8f140701a901a4f"
      )

      expect(hash_builder).to have_received(:new).with(
        "credentials" => {
          "expires" => true,
          "expires_at" => 1697414660,
          "id_token" => "25f98a87654654df537bddfc2eb2bcd6",
          "refresh_token" => nil,
          "token" => "237699305323155|dc16f036399dda7bc8f140701a901a4f",
          "token_type" => "Bearer"
        },
        "extra" => {
          "raw_info" => {
            "aud" => "be70560439f3c35adb6828fed79c1542",
            "email" => "lkertz@example.com",
            "email_verified" => true,
            "exp" => 1697364260,
            "family_name" => "Stuart",
            "given_name" => "Duncan",
            "iat" => 1697328260,
            "iss" => "https://dev-zkufvtd16kyxi2x1.uk.auth0.com/",
            "locale" => "en-GB",
            "name" => "Lauretta Kertzmann",
            "nickname" => "dgmstuart",
            "nonce" => "a1ab77d90ded3027fdd217a57f23af4e",
            "picture" => "https://example.com/picture",
            "sid" => "1783f72c80f7fff6a5aa39c22012fcd8",
            "sub" => "google-oauth1|121306855667663219395",
            "updated_at" => "2023-10-14T23:20:47.941Z"
          }
        },
        "info" => {},
        "provider" => "auth0",
        "uid" => "google-oauth1|121306855667663219395"
      )
    end
  end
end

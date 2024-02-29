# frozen_string_literal: true

require "spec_helper"
require "lib/omniauth_test_response_builder"

RSpec.describe OmniauthTestResponseBuilder do
  describe "#stub_auth_hash" do
    before { stub_const("Rails", double(env: double(production?: false))) } # rubocop:disable RSpec/VerifiedDoubles

    it "configures Omniauth to return a fixed hash from all requests" do
      auth_hash = instance_double("OmniAuth::AuthHash")
      hash_builder = class_double("OmniAuth::AuthHash", new: auth_hash)
      mock_auth_config = {}

      described_class.new(hash_builder:, mock_auth_config:).stub_auth_hash(id: double, name: double, expires_at: double)

      expect(mock_auth_config).to eq(facebook: auth_hash)
    end

    it "builds an auth hash based on the provided data" do
      hash_builder = class_double("OmniAuth::AuthHash", new: double)
      mock_auth_config = {}

      described_class.new(hash_builder:, mock_auth_config:).stub_auth_hash(
        id: 79911749339938642,
        name: "Lauretta Kertzmann",
        token: "237699305323155|dc16f036399dda7bc8f140701a901a4f",
        expires_at: 1546086985
      )

      expect(hash_builder).to have_received(:new).with(
        "provider" => "facebook",
        "uid" => 79911749339938642,
        "info" => {
          "name" => "Lauretta Kertzmann",
          "image" => "http://graph.facebook.com/v2.10/79911749339938642/picture"
        },
        "credentials" => {
          "token" => "237699305323155|dc16f036399dda7bc8f140701a901a4f",
          "expires_at" => 1546086985,
          "expires" => true
        },
        "extra" => {
          "raw_info" => {
            "name" => "Lauretta Kertzmann",
            "id" => 79911749339938642
          }
        }
      )
    end
  end
end

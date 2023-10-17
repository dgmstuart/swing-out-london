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
      expect(mock_auth_config).to eq(slack: auth_hash)
    end

    it "builds an auth hash based on the provided data" do
      hash_builder = class_double("OmniAuth::AuthHash", new: double)
      mock_auth_config = {}

      described_class.new(hash_builder:, mock_auth_config:).stub_auth_hash(
        id: "C536F34C",
        name: "Lauretta Kertzmann",
        token: "b1d2-773a72666cb7-80e99584d7d2-ed0be4d3c3840-55b620d612bab90de2c60f19a897878d"
      )

      expect(hash_builder).to have_received(:new).with(
        "provider" => :slack,
        "uid" => "C536F34C",
        "info" => {
          "name" => "Lauretta Kertzmann",
          "email" => nil,
          "email_verified" => nil,
          "nickname" => nil,
          "first_name" => "Lauretta",
          "last_name" => "Kertzmann",
          "gender" => nil,
          "image" => "https://example.com/avatar.jpg",
          "phone" => nil,
          "urls" => { "website" => nil }
        },
        "credentials" => {
          "id_token" => "a-very-long-token",
          "token" => "b1d2-773a72666cb7-80e99584d7d2-ed0be4d3c3840-55b620d612bab90de2c60f19a897878d",
          "refresh_token" => nil,
          "expires_in" => nil,
          "scope" => nil
        },
        "extra" => {
          "raw_info" => {
            "ok" => true,
            "sub" => "C536F34C",
            "https://slack.com/user_id" => "C536F34C",
            "https://slack.com/team_id" => "TEKLWQYP5",
            "name" => "Lauretta Kertzmann",
            "picture" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_512.jpg",
            "given_name" => "Lauretta",
            "family_name" => "Kertzmann",
            "locale" => "en-US",
            "https://slack.com/team_name" => "Swing Out London",
            "https://slack.com/team_domain" => "swingoutlondon",
            "https://slack.com/user_image_24" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_24.jpg",
            "https://slack.com/user_image_32" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_32.jpg",
            "https://slack.com/user_image_48" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_48.jpg",
            "https://slack.com/user_image_72" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_72.jpg",
            "https://slack.com/user_image_192" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_192.jpg",
            "https://slack.com/user_image_512" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_512.jpg",
            "https://slack.com/user_image_1024" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_1024.jpg",
            "https://slack.com/team_image_34" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_34.jpg",
            "https://slack.com/team_image_44" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_44.jpg",
            "https://slack.com/team_image_68" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_68.jpg",
            "https://slack.com/team_image_88" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_88.jpg",
            "https://slack.com/team_image_102" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_102.jpg",
            "https://slack.com/team_image_132" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_132.jpg",
            "https://slack.com/team_image_230" => "https://avatars.slack-edge.com/2018-12-05/495828053858_54cf95194971a730f2c5_230.jpg",
            "https://slack.com/team_image_default" => false,
            "iss" => "https://slack.com",
            "aud" => "495710848787.6049331372885",
            "exp" => 1697583583,
            "iat" => 1697583283,
            "auth_time" => 1697583283,
            "nonce" => "80d86a2cb8a43ee94d100618066aa1bc",
            "at_hash" => "45120de6679f0cad2b2869"
          }
        }
      )
    end
  end
end

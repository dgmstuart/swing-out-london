# frozen_string_literal: true

require "faker"
require "faker/slack"

class OmniauthTestResponseBuilder
  def initialize(hash_builder: OmniAuth::AuthHash, mock_auth_config: OmniAuth.config.mock_auth)
    @hash_builder = hash_builder
    @mock_auth_config = mock_auth_config
  end

  def stub_auth_hash(
    id: Faker::Slack.uid,
    name: Faker::Name.lindy_hop_name,
    token: SecureRandom.hex
  )
    raise "Can't stub authentication in production" if Rails.env.production?

    auth_hash = slack_auth_hash(id:, name:, token:)
    mock_auth_config[:slack] = auth_hash
  end

  private

  attr_reader :hash_builder, :mock_auth_config

  def slack_auth_hash(id:, name:, token:)
    first_name, *other_names = name.split
    last_name = other_names.join(" ")
    hash_builder.new(
      "provider" => :slack,
      "uid" => id,
      "info" => {
        "name" => name,
        "email" => nil,
        "email_verified" => nil,
        "nickname" => nil,
        "first_name" => first_name,
        "last_name" => last_name,
        "gender" => nil,
        "image" => "https://example.com/avatar.jpg",
        "phone" => nil,
        "urls" => { "website" => nil }
      },
      "credentials" => {
        "id_token" => "a-very-long-token",
        "token" => token,
        "refresh_token" => nil,
        "expires_in" => nil,
        "scope" => nil
      },
      "extra" => {
        "raw_info" => {
          "ok" => true,
          "sub" => id,
          "https://slack.com/user_id" => id,
          "https://slack.com/team_id" => "TEKLWQYP5",
          "name" => name,
          "picture" => "https://avatars.slack-edge.com/2022-02-02/3067504073456_edeaee73989a69e2787a_512.jpg",
          "given_name" => first_name,
          "family_name" => last_name,
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

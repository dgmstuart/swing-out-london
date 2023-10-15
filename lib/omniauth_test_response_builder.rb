# frozen_string_literal: true

require "faker"

class OmniauthTestResponseBuilder
  def initialize(hash_builder: OmniAuth::AuthHash, mock_auth_config: OmniAuth.config.mock_auth)
    @hash_builder = hash_builder
    @mock_auth_config = mock_auth_config
  end

  def stub_auth_hash(
    email: Faker::Internet.email,
    name: Faker::Name.lindy_hop_name,
    token: Faker::Auth0.access_token
  )
    raise "Can't stub authentication in production" if Rails.env.production?

    auth_hash = auth0_auth_hash(email:, name:, token:)
    mock_auth_config[:auth0] = auth_hash
  end

  private

  attr_reader :hash_builder, :mock_auth_config

  def auth0_auth_hash(email:, name:, token:)
    hash_builder.new(
      "provider" => "auth0",
      "uid" => "google-oauth1|121306855667663219395",
      "info" => {
        # info from the specific auth provider?
      },
      "credentials" => {
        "token" => token,
        "expires_at" => 1697414660,
        "expires" => true,
        "id_token" => "25f98a87654654df537bddfc2eb2bcd6",
        "token_type" => "Bearer",
        "refresh_token" => nil
      },
      "extra" => {
        "raw_info" => { # raw_info is the data normalized by Auth0
          "given_name" => "Duncan",
          "family_name" => "Stuart",
          "nickname" => "dgmstuart",
          "name" => name,
          "picture" => "https://example.com/picture",
          "locale" => "en-GB",
          "updated_at" => "2023-10-14T23:20:47.941Z",
          "email" => email,
          "email_verified" => true,
          "iss" => "https://dev-zkufvtd16kyxi2x1.uk.auth0.com/", # auth0 domain
          "aud" => "be70560439f3c35adb6828fed79c1542",
          "iat" => 1697328260, # expiry
          "exp" => 1697364260, # also expiry?
          "sub" => "google-oauth1|121306855667663219395",
          "sid" => "1783f72c80f7fff6a5aa39c22012fcd8",
          "nonce" => "a1ab77d90ded3027fdd217a57f23af4e"
        }
      }
    )
  end
end

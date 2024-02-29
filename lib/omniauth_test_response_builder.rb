# frozen_string_literal: true

require "faker"

class OmniauthTestResponseBuilder
  def initialize(hash_builder: OmniAuth::AuthHash, mock_auth_config: OmniAuth.config.mock_auth)
    @hash_builder = hash_builder
    @mock_auth_config = mock_auth_config
  end

  def stub_auth_hash(
    id: Faker::Facebook.uid,
    name: Faker::Name.lindy_hop_name,
    token: SecureRandom.hex,
    expires_at: 60.days.from_now.to_i
  )
    raise "Can't stub authentication in production" if Rails.env.production?

    auth_hash = facebook_auth_hash(id:, name:, token:, expires_at:)
    mock_auth_config[:facebook] = auth_hash
  end

  private

  attr_reader :hash_builder, :mock_auth_config

  def facebook_auth_hash(id:, name:, token:, expires_at:)
    hash_builder.new(
      "provider" => "facebook",
      "uid" => id,
      "info" => {
        "name" => name,
        "image" => "http://graph.facebook.com/v2.10/#{id}/picture"
      },
      "credentials" => {
        "token" => token,
        "expires_at" => expires_at,
        "expires" => true
      },
      "extra" => {
        "raw_info" => {
          "name" => name,
          "id" => id
        }
      }
    )
  end
end

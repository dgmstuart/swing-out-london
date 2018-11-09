# frozen_string_literal: true

module System
  module OmniAuthHelper
    OmniAuth.config.test_mode = true
    OmniAuth.config.logger = Logger.new('/dev/null')

    def stub_auth_hash(
      id: Faker::Number.number(17),
      name: Faker::Name.name,
      token: SecureRandom.hex
    )
      auth_hash = facebook_auth_hash(id: id, name: name, token: token)
      OmniAuth.config.mock_auth[:facebook] = auth_hash
    end

    def facebook_auth_hash(id:, name:, token:)
      OmniAuth::AuthHash.new(
        'provider' => 'facebook',
        'uid' => id,
        'info' => {
          'name' => name,
          'image' => "http://graph.facebook.com/v2.10/#{id}/picture"
        },
        'credentials' => {
          'token' => token,
          'expires_at' => 1546086985,
          'expires' => true
        },
        'extra' => {
          'raw_info' => {
            'name' => id,
            'id' => id
          }
        }
      )
    end
  end
end

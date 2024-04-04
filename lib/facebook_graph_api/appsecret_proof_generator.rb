# frozen_string_literal: true

module FacebookGraphApi
  # Generates a string proving that we know the `app_secret`, which we can pass
  # in certain calls to the Facbook Graph API.
  #
  # @see https://developers.facebook.com/docs/graph-api/securing-requests%20/#appsecret_proof appsecret_proof
  class AppsecretProofGenerator
    def initialize(app_secret: Rails.configuration.x.facebook.app_secret!)
      @app_secret = app_secret
    end

    def generate(auth_token)
      OpenSSL::HMAC.hexdigest(digest, app_secret, auth_token)
    end

    private

    attr_reader :app_secret

    def digest
      OpenSSL::Digest.new("SHA256")
    end
  end
end

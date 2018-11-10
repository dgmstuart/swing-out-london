# frozen_string_literal: true

module FacebookGraphApi
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
      OpenSSL::Digest::SHA256.new
    end
  end
end

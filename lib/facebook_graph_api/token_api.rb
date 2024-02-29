# frozen_string_literal: true

require "facebook_graph_api/http_client"

module FacebookGraphApi
  class TokenApi
    def initialize(
      base_url: Rails.configuration.x.facebook.api_base!,
      http_client: HTTP.use(logging: { logger: Rails.logger }),
      client_id: Rails.configuration.x.facebook.app_id!,
      client_secret: Rails.configuration.x.facebook.app_secret!
    )
      @base_url = base_url
      @http_client = http_client
      @client_id = client_id
      @client_secret = client_secret
    end

    # https://developers.facebook.com/docs/facebook-login/guides/access-tokens/get-long-lived
    def exchange_token(auth_token)
      http_client.get(
        uri("/oauth/access_token"),
        params: {
          grant_type: "fb_exchange_token",
          client_id:,
          client_secret:,
          fb_exchange_token: auth_token
        }
      )
    end

    private

    attr_reader :base_url, :http_client, :client_id, :client_secret

    def uri(path)
      URI.join(base_url, path).to_s
    end
  end
end

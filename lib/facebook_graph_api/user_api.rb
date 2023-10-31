# frozen_string_literal: true

require "facebook_graph_api/http_client"
require "facebook_graph_api/api"

module FacebookGraphApi
  class UserApi
    def initialize(
      auth_token:,
      authorized_id: nil,
      http_client_builder: FacebookGraphApi::HttpClient,
      api_builder: FacebookGraphApi::Api
    )
      @auth_token = auth_token
      @authorized_id = authorized_id
      @http_client_builder = http_client_builder
      @api_builder = api_builder
    end

    class << self
      def for_user(user)
        new(auth_token: user.token, authorized_id: user.auth_id)
      end
    end

    def profile(user_id)
      api.profile(user_id)
    end

    def revoke_login
      api.revoke_login(authorized_id)
    end

    private

    attr_reader :auth_token, :authorized_id, :api_builder, :http_client_builder

    def api
      client = http_client_builder.new(auth_token:)
      api_builder.new(client)
    end
  end
end

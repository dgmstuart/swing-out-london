# frozen_string_literal: true

require "facebook_graph_api/http_client"
require "facebook_graph_api/api"

module FacebookGraphApi
  class UserApi
    def initialize(
      user,
      http_client_builder: FacebookGraphApi::HttpClient,
      api_builder: FacebookGraphApi::Api
    )
      @user = user
      @http_client_builder = http_client_builder
      @api_builder = api_builder
    end

    class << self
      def for_user_attributes(token:, auth_id: nil)
        user = LoginSession::User.new({ "token" => token, "auth_id" => auth_id })
        new(user)
      end
    end

    def profile(user_id)
      api.profile(user_id)
    end

    def revoke_login
      api.revoke_login(user.auth_id)
    end

    private

    attr_reader :user, :api_builder, :http_client_builder

    def api
      client = http_client_builder.new(auth_token: user.token)
      api_builder.new(client)
    end
  end
end

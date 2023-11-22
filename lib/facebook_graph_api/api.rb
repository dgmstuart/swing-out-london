# frozen_string_literal: true

require "facebook_graph_api/http_client"

module FacebookGraphApi
  class Api
    def initialize(http_client)
      @http_client = http_client
    end

    def revoke_login(user_id)
      raise ArgumentError, "missing user id" if user_id.nil?

      http_client.delete("/#{user_id}/permissions")
    end

    def profile(user_id)
      raise ArgumentError, "missing user id" if user_id.nil?

      http_client.get("/#{user_id}")
    end

    private

    attr_reader :http_client
  end
end

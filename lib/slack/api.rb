# frozen_string_literal: true

require "slack/http_client"

module Slack
  class Api
    def initialize(http_client, logger: Rails.logger)
      @http_client = http_client
      @logger = logger
    end

    def revoke_login
      response = http_client.delete("/auth.revoke")

      error = response.fetch(:error, nil)
      if response.fetch(:ok) || error == "token_revoked"
        true
      else
        logger.error("Auth revocation failed: #{error}")
        false
      end
    end

    private

    attr_reader :http_client, :logger
  end
end

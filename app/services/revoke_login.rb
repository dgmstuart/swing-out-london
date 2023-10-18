# frozen_string_literal: true

require "slack/api"

class RevokeLogin
  def initialize(
    http_client_builder: Slack::HttpClient,
    api_builder: Slack::Api,
    logger: Rails.logger
  )
    @http_client_builder = http_client_builder
    @api_builder = api_builder
    @logger = logger
  end

  def revoke!(user)
    api_for(user.token).revoke_login.tap do
      logger.info("Auth id #{user.auth_id} revoked their login permissions")
    end
  end

  private

  attr_reader :http_client_builder, :api_builder, :logger

  def api_for(auth_token)
    http_client = http_client_builder.new(auth_token:)
    api_builder.new(http_client)
  end
end

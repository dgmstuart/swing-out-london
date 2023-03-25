# frozen_string_literal: true

require "facebook_graph_api/api"

class RevokeLogin
  def initialize(
    http_client_builder: FacebookGraphApi::HttpClient,
    api_builder: FacebookGraphApi::Api,
    logger: Rails.logger
  )
    @http_client_builder = http_client_builder
    @api_builder = api_builder
    @logger = logger
  end

  def revoke!(user)
    api_for(user.token).revoke_login(user.auth_id)
    logger.info("Auth id #{user.auth_id} revoked their login permissions")
  end

  private

  attr_reader :http_client_builder, :api_builder, :logger

  def api_for(auth_token)
    http_client = http_client_builder.new(auth_token: auth_token)
    api_builder.new(http_client)
  end
end

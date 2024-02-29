# frozen_string_literal: true

require "facebook_graph_api/api"

class RevokeLogin
  def initialize(
    api_builder: FacebookGraphApi::Api,
    logger: Rails.logger
  )
    @api_builder = api_builder
    @logger = logger
  end

  def revoke!(user)
    api = api_builder.for_token(user.token)
    api.revoke_login(user.auth_id)
    logger.info("Auth id #{user.auth_id} revoked their login permissions")
  end

  private

  attr_reader :api_builder, :logger
end

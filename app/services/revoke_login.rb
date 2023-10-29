# frozen_string_literal: true

require "facebook_graph_api/user_api"

class RevokeLogin
  def initialize(
    api_builder: FacebookGraphApi::UserApi,
    logger: Rails.logger
  )
    @api_builder = api_builder
    @logger = logger
  end

  def revoke!(user)
    api = api_builder.new(user)
    api.revoke_login
    logger.info("Auth id #{user.auth_id} revoked their login permissions")
  end

  private

  attr_reader :api_builder, :logger
end

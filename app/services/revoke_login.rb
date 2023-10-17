# frozen_string_literal: true

require "facebook_graph_api/api"

class RevokeLogin
  def initialize(
    client: Auth0ClientBuilder.new.build,
    logger: Rails.logger
  )
    @client = client
    @logger = logger
  end

  def revoke!(user)
    grant_id = ???
    user_id = ??
    client.delete_grant(user.id, grant.id)
    logger.info("User #{user.email} revoked their login permissions")
  end

  private

  attr_reader :client, :logger

end

class Auth0ClientBuilder
  def initialize(config = Rails.configuration.x.auth0)
    @config = config
  end

  def build
    Auth0Client.new(
      client_id: config.client_id,
      client_secret: config.client_secret,
      domain: config.domain,
      api_version: 2
    )
  end

  private

  attr_reader :config
end

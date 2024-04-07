# frozen_string_literal: true

# Responsible for checking that a user is authorized, by checking {Role}s, and
# creating a login session if they are.
class SessionCreator
  def initialize(login_session:, authoriser: Authoriser.new, logger: Rails.logger)
    @authoriser = authoriser
    @login_session = login_session
    @logger = logger
  end

  def create(user)
    if authoriser.authorised?(user)
      login_session.log_in!(auth_id: user.id, name: user.name, token: user.token, token_expires_at: user.expires_at)
      true
    else
      logger.warn("Auth id #{user.id} tried to log in, but was not in the allowed list")
      false
    end
  end

  attr_reader :authoriser, :login_session, :logger

  # @private
  class Authoriser
    def authorised?(auth_id)
      Role.find_by(facebook_ref: auth_id).present?
    end
  end
end

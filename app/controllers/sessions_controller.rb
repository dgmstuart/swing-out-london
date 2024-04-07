# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "website"
  include CityHelper

  def new; end

  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    user = AuthResponse.new(request.env)
    if authorised(user.id)
      after_login_path = return_to_session.path(fallback: events_path)
      login_session.log_in!(auth_id: user.id, name: user.name, token: user.token, token_expires_at: user.expires_at)
      redirect_to after_login_path
    else
      flash.alert = "Your Facebook ID for #{tc('site_name')} (#{user.id}) isn't in the approved list.\n" \
                    "If you've been invited to become an editor, " \
                    "please contact the main site admins and get them to add this ID"
      logger.warn("Auth id #{user.id} tried to log in, but was not in the allowed list")
      redirect_to action: :new
    end
  end

  def destroy
    login_session.log_out!
    redirect_to action: :new
  end

  def failure
    flash.alert = "There was a problem with your login to Facebook"
    logger.warn("Authorisation failed with: #{params[:message]}")

    redirect_to action: :new
  end

  private

  def authorised(auth_id)
    Role.find_by(facebook_ref: auth_id).present?
  end

  def login_session
    LoginSession.new(request)
  end

  def return_to_session
    ReturnToSession.new(request)
  end
end

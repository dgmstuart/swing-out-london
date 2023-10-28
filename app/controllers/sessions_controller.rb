# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "website"
  include CityHelper

  def new; end

  def create
    user = AuthResponse.new(request.env)
    if authorised?(user.id)
      login_session.log_in!(auth_id: user.id, name: user.name, token: user.token)
      redirect_to events_path
    else
      flash.alert = "Your Facebook ID for #{tc('site_name')} (#{user.id}) isn't in the approved list.\n" \
                    "If you've been invited to become an editor, please contact the main site admins and get them to add this ID"
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

  def authorised?(auth_id)
    Rails.application.config.x.facebook.editor_user_ids.include?(auth_id)
  end

  def login_session
    LoginSession.new(request)
  end
end

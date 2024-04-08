# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "website"
  include CityHelper

  def new; end

  def create
    user = AuthResponse.new(request.env)
    after_login_path = return_to_session.path(fallback: events_path)
    if SessionCreator.new(login_session:).create(user)
      redirect_to after_login_path
    else
      flash.alert = unknown_facebook_id_message(user.id)
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

  def unknown_facebook_id_message(user_id)
    "Your Facebook ID for #{tc('site_name')} (#{user_id}) isn't in the approved list.\n" \
      "If you've been invited to become an editor, " \
      "please contact the main site admins and get them to add this ID"
  end

  def login_session
    LoginSession.new(request)
  end

  def return_to_session
    ReturnToSession.new(request)
  end
end

# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "website"
  include CityHelper

  def new; end

  def create
    user = AuthResponse.new(request.env)
    if authorised?(user.email)
      login_session.log_in!(auth_id: user.email, name: user.name, token: user.token)
      redirect_to events_path
    else
      flash.alert = "Your email address (#{user.email}) is not in the list of editors.\n" \
                    "If you've been invited to become an editor, please contact the main site admins and get them to add you"
      logger.warn("#{user.email} tried to log in, but was not in the allowed list")

      redirect_to login_url
    end
  end

  def destroy
    login_session.log_out!
    redirect_to action: :new
  end

  def failure
    flash.alert = "There was a problem with your login"
    logger.warn("Authorisation failed with: #{params[:message]}")

    redirect_to action: :new
  end

  private

  def authorised?(email)
    Rails.application.config.x.admin.user_emails.include?(email)
  end

  def login_session
    LoginSession.new(request)
  end
end

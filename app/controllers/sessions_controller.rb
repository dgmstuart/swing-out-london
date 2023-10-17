# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "website"
  include CityHelper

  def new; end

  def create
    user = AuthResponse.new(request.env)
    login_session.log_in!(auth_id: user.id, name: user.name, token: user.token)

    redirect_to events_path
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

  def login_session
    LoginSession.new(request)
  end
end

# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'website'

  def new; end

  def create
    user = AuthResponse.new(request.env)
    if authorised?(user.id)
      LoginSession.new(request).log_in!(auth_id: user.id, name: user.name)
      redirect_to events_path
    else
      flash.alert = 'We didn\'t recognise your facebook account'
      redirect_to action: :new
    end
  end

  def destroy
    LoginSession.new(request).log_out!
    redirect_to action: :new
  end

  def failure
    flash.alert = 'There was a problem with your login to Facebook'
    logger.warn("Authorisation failed with: #{params[:message]}")

    redirect_to action: :new
  end

  private

  def authorised?(auth_id)
    Rails.application.config.x.facebook.admin_user_ids.include?(auth_id)
  end
end

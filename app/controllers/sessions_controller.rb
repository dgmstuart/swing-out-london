# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'website'

  def new; end

  def create
    auth_id = AuthResponse.new(request.env).id
    LoginSession.new(request).log_in!(auth_id)
    redirect_to events_path
  end

  def destroy
    LoginSession.new(request).log_out!
    redirect_to action: :new
  end
end

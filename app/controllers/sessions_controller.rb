# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'website'

  def new; end

  def create
    user = AuthResponse.new(request.env)
    LoginSession.new(request).log_in!(auth_id: user.id, name: user.name)
    redirect_to events_path
  end

  def destroy
    LoginSession.new(request).log_out!
    redirect_to action: :new
  end
end

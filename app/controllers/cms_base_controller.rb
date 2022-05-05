# frozen_string_literal: true

class CmsBaseController < ApplicationController
  before_action :authenticate

  layout 'cms'

  private

  def authenticate
    @current_user = login_session.user

    return true if @current_user.logged_in?

    redirect_to login_path
  end

  def audit_user
    { 'auth_id' => login_session.user.auth_id, 'name' => login_session.user.name }
  end

  def login_session
    LoginSession.new(request)
  end
end

# frozen_string_literal: true

class CmsBaseController < ApplicationController
  before_action :authenticate

  layout 'cms'

  helper_method :current_user
  attr_reader :current_user

  private

  def authenticate
    @current_user = login_session.user

    return true if @current_user.logged_in?

    redirect_to login_path
  end

  def audit_user
    { 'auth_id' => current_user.auth_id, 'name' => current_user.name }
  end

  def login_session
    LoginSession.new(request)
  end
end

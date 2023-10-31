# frozen_string_literal: true

class CmsBaseController < ActionController::Base # rubocop:disable Rails/ApplicationController
  before_action :authenticate
  before_action :set_controller_and_action_name

  layout "cms"

  helper_method :current_user
  attr_reader :current_user

  private

  def authenticate
    @current_user = login_session.user

    return true if @current_user.logged_in?

    return_to_session.store!(request.original_fullpath)

    redirect_to login_path
  end

  def audit_user
    { "auth_id" => current_user.auth_id, "name" => current_user.name }
  end

  def return_to_session
    ReturnToSession.new(request)
  end

  def login_session
    LoginSession.new(request)
  end

  def set_controller_and_action_name
    @controller_name = controller_name
    @action_name     = action_name
  end
end

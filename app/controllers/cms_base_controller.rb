# frozen_string_literal: true

class CMSBaseController < ApplicationController
  before_action :authenticate

  layout 'cms'

  private

  def authenticate
    @current_user = login_session.user

    return true if @current_user.logged_in?

    redirect_to login_path
  end

  def login_session
    LoginSession.new(request)
  end
end

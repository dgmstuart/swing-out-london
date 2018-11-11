# frozen_string_literal: true

class CMSBaseController < ApplicationController
  before_action :authenticate
  before_action :set_paper_trail_whodunnit

  layout 'cms'

  def user_for_paper_trail
    login_session.user.auth_id
  end

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

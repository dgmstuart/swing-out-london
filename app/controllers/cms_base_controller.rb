# frozen_string_literal: true

class CMSBaseController < ApplicationController
  before_action :authenticate

  layout 'cms'

  private

  def authenticate
    return true if logged_in?

    redirect_to login_path
  end

  def logged_in?
    LoginSession.new(request).logged_in?
  end
end

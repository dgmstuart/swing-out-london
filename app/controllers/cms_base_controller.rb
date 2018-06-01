class CMSBaseController < ApplicationController
  before_filter :authenticate

  layout 'cms'

  private

  def authenticate
    session[:authenticated] =nil
    authenticate_or_request_with_http_basic do |username, password|
      session[:authenticated] =( LOGINS[username] == Digest::MD5.hexdigest(password) )
    end
  end
end

# frozen_string_literal: true

class UsersController < CmsBaseController
  layout "cms"

  def show; end

  def destroy
    RevokeLogin.new.revoke!(login_session.user)
    login_session.log_out!
    flash.notice = "Your login permissions have been revoked in Facebook"

    redirect_to login_path
  end
end

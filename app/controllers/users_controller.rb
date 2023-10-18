# frozen_string_literal: true

class UsersController < CmsBaseController
  layout "cms"

  def show; end

  def destroy
    result = RevokeLogin.new.revoke!(login_session.user)
    login_session.log_out!
    if result
      flash.notice = "Your login permissions have been revoked"
    else
      flash.alert = "Error: failed to revoke your login permissions. Contact an admin."
    end

    redirect_to login_path
  end
end

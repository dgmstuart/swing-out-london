# frozen_string_literal: true

class UsersController < CmsBaseController
  layout "cms"

  def show
    render locals: { access_token_expires_at: Time.zone.at(login_session.user.token_expires_at) }
  end

  def destroy
    RevokeLogin.new.revoke!(login_session.user)
    login_session.log_out!
    flash.notice = "Your login permissions have been revoked in Facebook"

    redirect_to login_path
  end
end

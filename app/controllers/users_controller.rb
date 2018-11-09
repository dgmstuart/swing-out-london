# frozen_string_literal: true

class UsersController < CMSBaseController
  layout 'cms'

  def show; end

  def destroy
    RevokeLogin.new.revoke!(login_session.user)
    login_session.log_out!

    redirect_to login_path
  end
end

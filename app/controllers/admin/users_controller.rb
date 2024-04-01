# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      users = UsersListing.for_user(current_user).users

      render locals: { users: }
    end

    def destroy
      Role.find_by(facebook_ref: params[:id]).destroy!

      redirect_to admin_users_path
    end
  end
end

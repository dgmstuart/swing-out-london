# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      users = UsersListing.for_user(current_user).users
      role_select_options = Role::ROLES.map { |role| [role.capitalize, role] }

      render locals: { users:, new_user: Role.new, role_select_options: }
    end

    def create
      Role.create!(new_role_params)

      redirect_to admin_users_path
    end

    def destroy
      Role.find_by(facebook_ref: params[:id]).destroy!

      redirect_to admin_users_path
    end

    private

    def new_role_params
      params.require(:role).permit(:facebook_ref, :role)
    end
  end
end

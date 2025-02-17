# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      render locals: index_locals(new_user: Role.new)
    end

    def create
      role = Role.new(new_role_params)
      if role.save
        redirect_to admin_users_path
      else
        render :index, locals: index_locals(new_user: role)
      end
    end

    def update
      Role.find_by(facebook_ref: params[:id]).update!(update_role_params)

      redirect_to admin_users_path
    end

    def destroy
      Role.find_by(facebook_ref: params[:id]).destroy!

      redirect_to admin_users_path
    end

    private

    def index_locals(new_user:)
      users = UsersListing.for_user(current_user).users
      role_select_options = Role::ROLES.map { |role| [role.capitalize, role] }

      { users:, new_user:, role_select_options: }
    end

    def new_role_params
      params.require(:role).permit(:facebook_ref, :role)
    end

    def update_role_params
      params.permit(:role)
    end
  end
end

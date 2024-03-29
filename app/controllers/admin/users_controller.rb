# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      users = UsersListing.new(
        users: User.all,
        user_name_finder: UserName.as_user(login_session.user)
      ).users

      render locals: { users: }
    end
  end
end

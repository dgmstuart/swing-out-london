# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      render locals: { users: User.all }
    end
  end
end

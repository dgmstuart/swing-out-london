# frozen_string_literal: true

class UsersListing
  def initialize(users:, user_name_finder:)
    @users = users
    @user_name_finder = user_name_finder
  end

  def users
    @users.map { build_user(_1) }
  end

  User = Data.define(:id, :admin?, :name)

  private

  attr_reader :user_name_finder

  def build_user(user)
    id = user.id
    name = user_name_finder.name_for(id)
    User.new(id:, admin?: user.admin?, name:)
  end
end

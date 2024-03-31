# frozen_string_literal: true

class UsersListing
  def initialize(roles:, user_name_finder:)
    @roles = roles
    @user_name_finder = user_name_finder
  end

  def users
    @roles.map { build_user(_1) }
  end

  User = Data.define(:id, :admin?, :name)

  private

  attr_reader :user_name_finder

  def build_user(role)
    id = role.facebook_ref
    name = user_name_finder.name_for(id)
    User.new(id:, admin?: role.admin?, name:)
  end
end

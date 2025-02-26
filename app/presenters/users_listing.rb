# frozen_string_literal: true

# Presenter for displaying a list of "Users" based on the {Role}s stored in the
# database.
class UsersListing
  def initialize(current_user_id:, user_name_finder:, roles: Role.real)
    @roles = roles
    @current_user_id = current_user_id
    @user_name_finder = user_name_finder
  end

  class << self
    def for_user(session_user)
      new(
        current_user_id: session_user.auth_id,
        user_name_finder: UserName.as_user(session_user)
      )
    end
  end

  def users
    @roles.map { build_user(_1) }
  end

  User = Data.define(:id, :admin?, :current?, :name) do
    def to_param
      id.to_s
    end
  end

  private

  attr_reader :current_user_id, :user_name_finder

  def build_user(role)
    id = role.facebook_ref
    User.new(
      name: user_name_finder.name_for(id),
      id:,
      admin?: role.admin?,
      current?: id == current_user_id
    )
  end
end

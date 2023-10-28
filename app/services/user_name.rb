# frozen_string_literal: true

class UserName
  def initialize(
    user:,
    api_builder: FacebookGraphApi::UserApi
  )
    @user = user
    @api_builder = api_builder
  end

  def name_for(user_id)
    api = api_builder.new(user)
    profile = api.profile(user_id)
    profile.fetch("name")
  end

  private

  attr_reader :user, :api_builder
end

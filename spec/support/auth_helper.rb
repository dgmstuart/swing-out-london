# frozen_string_literal: true

require "support/omniauth_helper"
require "support/facebook_helper"
require "faker/facebook"

module AuthHelper
  include OmniAuthHelper
  include FacebookHelper

  def stub_login(id: Faker::Facebook.uid, name: Faker::Name.lindy_hop_name, admin: false)
    stub_auth_hash(id:, name:)
    if admin
      create(:admin, facebook_ref: id)
    else
      create(:editor, facebook_ref: id)
    end
  end

  def skip_login(after_login_path = "/events", id: Faker::Facebook.uid, name: Faker::Name.lindy_hop_name, admin: false)
    user = instance_double(LoginSession::User,
                           name:,
                           name_with_role: name,
                           admin?: admin,
                           auth_id: id,
                           token: "a-super-secret-token",
                           logged_in?: true)
    login_session = instance_double(LoginSession, "Fake login", user:)
    allow(LoginSession).to receive(:new).and_return(login_session)
    visit after_login_path
  end
end

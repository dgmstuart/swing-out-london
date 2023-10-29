# frozen_string_literal: true

require "support/omniauth_helper"
require "support/facebook_helper"
require "faker/facebook"

module AuthHelper
  include OmniAuthHelper
  include FacebookHelper

  RSpec.configure do |config|
    config.before(:each, type: :system) do
      stub_login
    end
  end

  def stub_login(id: Faker::Facebook.uid, name: Faker::Name.lindy_hop_name, admin: false)
    stub_auth_hash(id:, name:)
    ids = if admin
            { editor_user_ids: [], admin_user_ids: [id] }
          else
            { editor_user_ids: [id], admin_user_ids: [] }
          end
    stub_facebook_config(ids)
  end

  def skip_login
    name = Faker::Name.lindy_hop_name
    user = instance_double(LoginSession::User,
                           name:,
                           name_with_role: name,
                           admin?: false,
                           auth_id: Faker::Facebook.uid,
                           logged_in?: true)
    login_session = instance_double(LoginSession, "Fake login", user:)
    allow(LoginSession).to receive(:new).and_return(login_session)
  end
end

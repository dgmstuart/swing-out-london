# frozen_string_literal: true

require "support/system/omniauth_helper"
require "faker/auth0"

module System
  module AuthHelper
    include OmniAuthHelper

    RSpec.configure do |config|
      config.before(:each, type: :system) do
        stub_login
      end
    end

    def stub_login(email: Faker::Internet.email, name: Faker::Name.lindy_hop_name)
      stub_auth_hash(email:, name:)
      Rails.application.config.x.admin.user_emails = [email]
    end

    def skip_login
      user = instance_double(LoginSession::User,
                             name: Faker::Name.lindy_hop_name,
                             auth_id: Faker::Auth0.uid,
                             logged_in?: true)
      login_session = instance_double(LoginSession, "Fake login", user:)
      allow(LoginSession).to receive(:new).and_return(login_session)
    end
  end
end

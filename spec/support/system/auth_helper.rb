# frozen_string_literal: true

require 'support/system/omniauth_helper'

module System
  module AuthHelper
    include OmniAuthHelper
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        stub_login
        driven_by :rack_test
      end

      config.before(:each, type: :system, js: true) do
        driven_by :selenium_chrome_headless
      end
    end

    def stub_login(id: Faker::Number.number(17), name: Faker::Name.name)
      stub_auth_hash(id: id, name: name)
      Rails.application.config.x.facebook.admin_user_ids = [id]
    end

    def skip_login
      user = instance_double(LoginSession::User, name: Faker::Name.name, logged_in?: true)
      login_session = instance_double(LoginSession, 'Fake login', user: user)
      allow(LoginSession).to receive(:new).and_return(login_session)
    end
  end
end

# frozen_string_literal: true

require 'support/system/omniauth_helper'

module System
  module AuthHelper
    include OmniAuthHelper
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
        stub_auth_hash
      end

      config.before(:each, type: :system, js: true) do
        driven_by :selenium_chrome_headless
      end
    end

    def skip_login
      login_session = instance_double(LoginSession, 'Fake login', logged_in?: true)
      allow(LoginSession).to receive(:new).and_return(login_session)
    end
  end
end

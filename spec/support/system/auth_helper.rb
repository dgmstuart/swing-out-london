# frozen_string_literal: true

module System
  module AuthHelper
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      config.before(:each, type: :system, js: true) do
        driven_by :selenium_chrome_headless
      end
    end

    OmniAuth.config.test_mode = true

    def skip_login
      login_session = instance_double(LoginSession, 'Fake login', logged_in?: true)
      allow(LoginSession).to receive(:new).and_return(login_session)
    end
  end
end

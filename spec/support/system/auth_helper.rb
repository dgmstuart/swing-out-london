# frozen_string_literal: true

module System
  module AuthHelper
    def login
      user = 'foo'
      pw = 'bar'
      stub_const('LOGINS', user => Digest::MD5.hexdigest(pw.to_s))

      page.driver.browser.basic_authorize(user, pw)
    end

    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      config.before(:each, type: :system, js: true) do
        driven_by :selenium_chrome_headless
      end
    end
  end
end

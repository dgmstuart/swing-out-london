# frozen_string_literal: true

# Override Capybara's default selenium_headless driver:
Capybara.register_driver :selenium_headless do |app|
  Capybara::Selenium::Driver.load_selenium # selenium-webdriver is require: false in the Gemfile

  browser_options = Selenium::WebDriver::Firefox::Options.new(
    # 750x1900 is enough to fit the whole event form:
    args: ["-headless", "-width=750", "-height=1900"],
    prefs: {
      "dom.events.asyncClipboard.readText" => true,
      "dom.events.testing.asyncClipboard" => true
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
end

module System
  module Drivers
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      config.before(:each, :js, type: :system) do
        driven_by :selenium_headless
      end
    end
  end
end

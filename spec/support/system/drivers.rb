# frozen_string_literal: true

# Override Capybara's selenium_chrome_headless driver to disable the chrome search engine selection modal
# If Capybara adds the --disable-search-engine-choice-screen option as a default, we can delete this override.
# This is mostly a copy of the definition from the Capybara source:
Capybara.register_driver :selenium_chrome_headless do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--headless=new")
    opts.add_argument("--disable-gpu") if Gem.win_platform?
    opts.add_argument("--disable-site-isolation-trials")
    opts.add_argument("--disable-search-engine-choice-screen")
  end

  Capybara::Selenium::Driver.new(app, **{ :browser => :chrome, options_key => browser_options })
end

module System
  module Drivers
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      config.before(:each, :js, type: :system) do
        driven_by :selenium_chrome_headless
        current_window.resize_to(750, 1900) # 750x1900 is enough to fit the whole event form
      end
    end
  end
end

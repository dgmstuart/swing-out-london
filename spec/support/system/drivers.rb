# frozen_string_literal: true

module System
  module Drivers
    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      config.before(:each, :js, type: :system) do
        driven_by :selenium_chrome_headless
      end
    end
  end
end

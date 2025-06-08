# frozen_string_literal: true

require "capybara/cuprite"

module System
  module Drivers
    Capybara.register_driver(:cuprite) do |app|
      Capybara::Cuprite::Driver.new(app, window_size: [750, 1900]) # 750x1900 is enough to fit the whole event form
    end

    RSpec.configure do |config|
      config.before(:each, type: :system) do
        driven_by :rack_test
      end

      Capybara.javascript_driver = :cuprite

      config.before(:each, :js, type: :system) do
        driven_by :cuprite
      end
    end
  end
end

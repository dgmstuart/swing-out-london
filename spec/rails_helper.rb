# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
  add_group 'Presenters', 'app/presenters'
end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'support/vcr'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  require 'support/controller/auth_helper'
  require 'support/system/auth_helper'
  require 'support/system/drivers'
  config.include Controller::AuthHelper, type: :controller
  config.include System::AuthHelper, type: :system
  config.include System::Drivers, type: :system
end

# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!

  require File.expand_path('support/controller/auth_helper.rb', __dir__)
  require File.expand_path('support/system/auth_helper.rb', __dir__)
  config.extend Controller::AuthHelper, type: :controller
  config.include System::AuthHelper, type: :system
end

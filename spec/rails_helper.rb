require 'simplecov'
SimpleCov.start 'rails'

require 'spec_helper'
require 'securerandom'

# Env variables which must exist before initializers are run:
ENV["IP_BLOCKLIST"] = '1.1.1.1'
ENV["SWINGOUTLONDON_SECRET_TOKEN"] = SecureRandom.hex(64)
ENV["SWINGOUTLONDON_SECRET_KEY_BASE"] = SecureRandom.hex(64)

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!

  require File.expand_path("../support/macros/auth_helper.rb", __FILE__)
  require File.expand_path("../support/macros/feature_auth_helper.rb", __FILE__)
  config.extend AuthHelper, type: :controller
  config.include FeatureAuthHelper, type: :feature
end

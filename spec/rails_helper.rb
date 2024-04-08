# frozen_string_literal: true

require "support/simplecov"
require "spec_helper"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "support/vcr"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  require "support/auth_helper"
  require "support/system/drivers"
  require "support/system/form_helper"
  require "support/system/menu_helper"
  require "support/custom_matchers/have_description_matching"
  config.include AuthHelper, type: :system
  config.include AuthHelper, type: :request
  config.include System::Drivers, type: :system
  config.include System::FormHelper, type: :system
  config.include HaveDescriptionMatching, type: :system
  config.include MenuHelper, type: :system
end

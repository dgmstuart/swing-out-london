# frozen_string_literal: true

require "simplecov"
SimpleCov.start "rails" do
  add_group "Services", "app/services"
  add_group "Presenters", "app/presenters"
end

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
  config.include AuthHelper, type: :system
  config.include AuthHelper, type: :request
  config.include System::Drivers, type: :system
  config.include System::FormHelper, type: :system
end

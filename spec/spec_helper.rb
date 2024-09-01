# frozen_string_literal: true

require "support/webmock"

RSpec.configure do |config|
  # If any specs have a "focus" tag - only run those specs
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.order = :random

  # shared_context_metadata_behavior will default to `:apply_to_host_groups` in RSpec 4
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    # include_chain_clauses_in_custom_matcher_descriptions will default to `true` in RSpec 4:
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    if config.files_to_run.count > 1
      # Don't verify that doubled objects exist if only runnig one file
      mocks.verify_doubled_constant_names = true
    end
  end

  # used for --seed when randomising specs
  Kernel.srand config.seed
end

$LOAD_PATH << File.expand_path("..", __dir__)

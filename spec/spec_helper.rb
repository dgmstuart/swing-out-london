# frozen_string_literal: true

RSpec.configure do |config|
  # If any specs have a "focus" tag - only run those specs
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

$LOAD_PATH << File.expand_path('..', __dir__)

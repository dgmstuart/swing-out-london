RSpec.configure do |config|
  # If any specs have a "focus" tag - only run those specs
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

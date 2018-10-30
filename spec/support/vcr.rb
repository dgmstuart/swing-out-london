# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<FACEBOOK_API_AUTH_TOKEN>') { ENV['FACEBOOK_API_AUTH_TOKEN'] }
end

VCR.turn_off!

RSpec.configure do |config|
  config.before(:all, :vcr) do
    VCR.turn_on!
  end

  config.after(:all, :vcr) do
    VCR.turn_off!
  end
end

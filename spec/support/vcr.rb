# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
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

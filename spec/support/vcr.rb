# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:appsecret_proof)
    ]
  }
  c.filter_sensitive_data("<BEARER_TOKEN>") do |interaction|
    interaction.request.headers.fetch("Authorization", []).first.to_s.gsub(/Bearer\s+[^\s]+/, "Bearer <AUTH TOKEN>")
  end
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

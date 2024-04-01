# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:appsecret_proof)
    ]
  }
  c.filter_sensitive_data("<FACEBOOK_API_AUTH_TOKEN>") { ENV.fetch("FACEBOOK_API_AUTH_TOKEN", nil) }
  c.filter_sensitive_data("<APPSECRET_PROOF>") do |interaction|
    query = URI.parse(interaction.request.uri).query
    CGI.parse(query)["appsecret_proof"].first
  end
  c.filter_sensitive_data("<BEARER_TOKEN>") do |interaction|
    interaction.request.headers.fetch("Authorization", "").first.gsub(/Bearer \S+/, "Bearer <BEARER_TOKEN>")
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

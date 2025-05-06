# frozen_string_literal: true

require "omniauth_test_response_builder"

module OmniAuthHelper
  OmniAuth.config.test_mode = true
  OmniAuth.config.logger = Logger.new(File::NULL)

  def stub_auth_hash(**)
    OmniauthTestResponseBuilder.new.stub_auth_hash(**)
  end
end

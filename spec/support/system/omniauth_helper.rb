# frozen_string_literal: true

module System
  module OmniAuthHelper
    OmniAuth.config.test_mode = true
    OmniAuth.config.logger = Logger.new('/dev/null')

    def stub_auth_hash(*args)
      OmniauthTestResponseBuilder.new.stub_auth_hash(*args)
    end
  end
end

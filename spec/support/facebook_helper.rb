# frozen_string_literal: true

module FacebookHelper
  def stub_facebook_config(methods)
    allow(Rails.configuration.x.facebook).to receive_messages(methods)
  end
end

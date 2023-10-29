# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Preventing session fixation" do
  it "reset_session is called after login" do
    stub_login
    allow_any_instance_of(SessionsController).to receive(:reset_session) # rubocop:disable RSpec/AnyInstance

    get auth_facebook_callback_path

    aggregate_failures do
      expect(response).to redirect_to("/events")
      expect(controller).to have_received(:reset_session).once
    end
  end
end

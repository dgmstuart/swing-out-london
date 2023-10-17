# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login Revocation" do
  it "admins can deauthorise Swing Out London's permissions", :vcr do
    config = Rails.configuration.x.auth0
    allow(config).to receive_messages(
      client_id!: "not-so-secret-id",
      client_secret!: "super-secret-secret",
      doamain!: "auth0domainthisisprobablywrong",
      admin_user_ids: [12345678901234567]
    )

    stub_auth_hash(email: "aminns@example.com")

    visit "/account"

    click_button "Log in"

    # TEMP - remove once we have implemented redirect:
    visit "/account"

    VCR.use_cassette("disable_login") do
      click_button "Disable my login"
    end

    expect(page).to have_header("Admin Login")
    expect(page).to have_content("Your login permissions have been revoked")
    expect(page).to have_button("Log in")

    visit "/events"
    expect(page).to have_button("Log in")
  end
end

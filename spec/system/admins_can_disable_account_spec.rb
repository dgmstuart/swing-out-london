# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login Revocation" do
  it "admins can deauthorise Swing Out Londons's Slack permissions", :vcr do
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

  context "when the deauthorisation failed", :vcr do
    it "shows an error" do
      visit "/account"

      click_button "Log in"

      stub_auth_hash(token: "not-a-real-token")

      # TEMP - remove once we have implemented redirect:
      visit "/account"

      VCR.use_cassette("disable_login_error") do
        click_button "Disable my login"
      end

      expect(page).to have_header("Admin Login")
      expect(page).to have_content("Error: failed to revoke your login permissions")
      expect(page).to have_button("Log in")

      visit "/events"
      expect(page).to have_button("Log in")
    end
  end
end

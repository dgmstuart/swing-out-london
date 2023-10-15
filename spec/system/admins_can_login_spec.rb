# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login" do
  it "admins can login and access admin pages" do
    stub_auth_hash(email: "aminns@example.com", name: "Al Minns")
    allow(Rails.application.config.x.admin)
      .to receive(:user_emails)
      .and_return(["aminns@example.com"])

    visit "/events"

    expect(page).not_to have_header("Events")

    click_button "Log in"

    expect(page).to have_header("Events")
    expect(page).to have_content("Al Minns")
  end

  context "when the user isn't in the approved list" do
    it "disallows the user from signing in, but shows them their Facebook ID" do
      stub_auth_hash(email: "freddie@example.com", name: "Fred Astaire")
      allow(Rails.application.config.x.admin)
        .to receive(:emails)
        .and_return([])

      visit "/events"

      click_button "Log in"

      expect(page).to have_content(
        "Your email address (freddie@example.com) is not in the list of editors."
      )
      expect(page).not_to have_header("Events")
    end
  end

  context "when authentication failed" do
    it "displays an alert" do
      OmniAuth.config.mock_auth[:auth0] = :no_authorisation_code

      visit "/events"

      click_button "Log in"

      expect(page).to have_content("There was a problem with your login")
      expect(page).not_to have_header("Events")
    end
  end
end

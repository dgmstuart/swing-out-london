# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login" do
  it "admins can login and access admin pages" do
    stub_auth_hash(id: 12345678901234567, name: "Al Minns")
    allow(Rails.application.config.x.facebook)
      .to receive(:admin_user_ids)
      .and_return([12345678901234567])

    visit "/events"

    expect(page).not_to have_header("Events")

    click_button "Log in"

    expect(page).to have_header("Events")
    expect(page).to have_content("Al Minns")
  end

  context "when the user isn't in the approved list" do
    it "disallows the user from signing in, but shows them their Facebook ID" do
      stub_auth_hash(id: 76543210987654321, name: "Fred Astaire")
      allow(Rails.application.config.x.facebook)
        .to receive(:admin_user_ids)
        .and_return([])

      visit "/events"

      click_button "Log in"

      expect(page).to have_content(
        "Your Facebook ID for Swing Out London (76543210987654321) isn't in the approved list"
      )
      expect(page).not_to have_header("Events")
    end
  end

  context "when authentication failed" do
    it "displays an alert" do
      OmniAuth.config.mock_auth[:facebook] = :no_authorisation_code

      visit "/events"

      click_button "Log in"

      expect(page).to have_content("There was a problem with your login to Facebook")
      expect(page).not_to have_header("Events")
    end
  end
end

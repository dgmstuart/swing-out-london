# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login" do
  it "admins can login and access admin pages" do
    stub_auth_hash(name: "Al Minns")
    visit "/events"

    expect(page).not_to have_header("Events")

    click_button "Log in"

    expect(page).to have_header("Events")
    expect(page).to have_content("Al Minns")
  end

  context "when authentication failed" do
    it "displays an alert" do
      OmniAuth.config.mock_auth[:slack] = :no_authorisation_code

      visit "/events"

      click_button "Log in"

      expect(page).to have_content("There was a problem with your login")
      expect(page).not_to have_header("Events")
    end
  end

  context "when the slack team isn't the one we're using" do
    it "displays an alert" do
      stub_auth_hash(team: "NOTOURTEAM")
      visit "/events"

      expect(page).not_to have_header("Events")

      click_button "Log in"

      expect(page).to have_content("There was a problem with your login")
      expect(page).not_to have_header("Events")
    end
  end
end

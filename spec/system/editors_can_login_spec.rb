# frozen_string_literal: true

require "rails_helper"
require "support/facebook_helper"

RSpec.describe "Editor Login" do
  include FacebookHelper

  it "Editors can login and access editor pages" do
    stub_auth_hash(id: 12345678901234567, name: "Al Minns")
    stub_facebook_config(editor_user_ids: [12345678901234567], admin_user_ids: [])

    visit "/events/new"

    expect(page).not_to have_header("New event")

    click_button "Log in"

    expect(page).to have_header("New event")
    expect(page).to have_content("Al Minns")
  end

  it "Admins can login and access editor pages" do
    stub_auth_hash(id: 12345678901234567, name: "Herbert White")
    stub_facebook_config(editor_user_ids: [], admin_user_ids: [12345678901234567])

    visit "/events"

    expect(page).not_to have_header("Events")

    click_button "Log in"

    expect(page).to have_header("Events")
    expect(page).to have_content("Herbert White (Admin)")
  end

  context "when the user isn't in the approved list" do
    it "disallows the user from signing in, but shows them their Facebook ID" do
      stub_auth_hash(id: 76543210987654321, name: "Fred Astaire")
      stub_facebook_config(editor_user_ids: [], admin_user_ids: [])

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

  context "when starting login from /login (ie. no return_to page)" do
    it "lands on the event list page after successful login" do
      stub_auth_hash(id: 12345678901234567, name: "Al Minns")
      stub_facebook_config(editor_user_ids: [12345678901234567], admin_user_ids: [])

      visit "/login"

      expect(page).not_to have_header("Events")

      click_button "Log in"

      expect(page).to have_header("Events")
      expect(page).to have_content("Al Minns")
    end
  end
end

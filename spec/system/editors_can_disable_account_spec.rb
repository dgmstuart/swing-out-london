# frozen_string_literal: true

require "rails_helper"
require "spec/support/facebook_helper"

RSpec.describe "Editor Login Revocation" do
  include FacebookHelper
  it "Editors can deauthorise Swing Out Londons facebook permissions", :vcr do
    stub_facebook_config(
      api_base!: "https://graph.facebook.com/",
      api_auth_token!: "super-secret-token",
      app_secret!: "super-secret-secret",
      editor_user_ids: [12345678901234567]
    )

    stub_auth_hash(id: 12345678901234567)

    visit "/account"

    click_button "Log in"

    VCR.use_cassette("disable_login") do
      click_button "Disable my login"
    end

    expect(page).to have_content("Editor Login")
    expect(page).to have_content("Your login permissions have been revoked in Facebook")
    expect(page).to have_button("Log in")

    visit "/events"
    expect(page).to have_button("Log in")
  end
end

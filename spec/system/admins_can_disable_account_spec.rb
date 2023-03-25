# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login Revocation" do
  it "admins can deauthorise Swing Out Londons facebook permissions", :vcr do
    config = Rails.configuration.x.facebook
    allow(config).to receive(:api_base!).and_return("https://graph.facebook.com/")
    allow(config).to receive(:api_auth_token!).and_return("super-secret-token")
    allow(config).to receive(:app_secret!).and_return("super-secret-secret")
    allow(config).to receive(:admin_user_ids).and_return([12345678901234567])

    stub_auth_hash(id: 12345678901234567)

    visit "/account"

    click_on "Log in with Facebook"

    # TEMP - remove once we have implemented redirect:
    visit "/account"

    VCR.use_cassette("disable_login") do
      click_on "Disable my login"
    end

    expect(page).to have_header("Admin Login")
    expect(page).to have_content("Your login permissions have been revoked in Facebook")
    expect(page).to have_link("Log in with Facebook")

    visit "/events"
    expect(page).to have_link("Log in with Facebook")
  end
end

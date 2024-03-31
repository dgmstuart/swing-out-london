# frozen_string_literal: true

require "rails_helper"
require "support/facebook_helper"

RSpec.describe "Refreshing Facebook access tokens" do
  include FacebookHelper
  include ActiveSupport::Testing::TimeHelpers

  it "Editors can login and access editor pages" do
    stub_auth_hash(id: 12345678901234567, expires_at: 1709166148)
    stub_facebook_config(
      app_id!: "4pp1D",
      app_secret!: "4pp53cr3t"
    )
    create(:editor, facebook_ref: 12345678901234567)
    travel_to "2024-02-01"

    visit "/account"
    click_on "Log in"

    expect(page).to have_content("Facebook access token will expire in 29 days")

    response_body = {
      access_token: "a-super-secret-token",
      token_type: "bearer",
      expires_in: 5184000 # exactly 60 days
    }
    stub_request(:get, %r{https://graph\.facebook\.com/oauth/access_token\?client_id=4pp1D&client_secret=4pp53cr3t&fb_exchange_token=.+&grant_type=fb_exchange_token})
      .to_return(status: 200, body: response_body.to_json)

    click_on("Refresh token")

    expect(page).to have_content("Facebook access token will expire in 60 days")
  end
end

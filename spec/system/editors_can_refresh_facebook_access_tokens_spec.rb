# frozen_string_literal: true

require "rails_helper"
require "support/facebook_helper"

RSpec.describe "Refreshing Facebook access tokens" do
  include FacebookHelper

  it "Editors can login and access editor pages" do
    stub_auth_hash(id: 12345678901234567, expires_at: 1709166148)
    stub_facebook_config(editor_user_ids: [12345678901234567], admin_user_ids: [])

    visit "/account"
    click_on "Log in"

    expect(page).to have_content("Facebook access token will expire at 2024-02-29 00:22:28 +0000")

    click_on("Refresh token")

    expect(page).to have_content("Facebook access token will expire at fooo")
  end
end

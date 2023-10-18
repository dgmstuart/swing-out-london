# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Login" do
  it "admins can log out" do
    stub_login(name: "Al Minns")

    visit "/events"

    click_button "Log in with Facebook"

    click_link "Al Minns"

    click_button "Log out"
    expect(page).to have_button("Log in with Facebook")

    visit "/events"
    expect(page).to have_button("Log in with Facebook")
  end
end

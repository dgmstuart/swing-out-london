# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can view an audit log" do
  it "showing a list of audited events" do
    stub_login(admin: true)

    visit "/login"
    click_button "Log in"

    create(:event)
    create(:venue)
    create(:organiser)

    click_link "Audit Log"

    expect(page).to have_content("Missing name create Event")
    expect(page).to have_content("Missing name create Venue")
    expect(page).to have_content("Missing name create Organiser")
  end

  context "when logged in as a non-admin" do
    it "does not allow access" do
      stub_login(admin: false)

      visit "/login"
      click_button "Log in"

      expect(page).not_to have_content("Audit Log")

      visit "/admin/audit_log"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end
end

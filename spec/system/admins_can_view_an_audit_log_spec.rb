# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can view an audit log" do
  around do |example|
    ClimateControl.modify(CANONICAL_HOST: "www.swingoutlondon.co.uk") { example.run }
  end

  it "showing a list of audited events" do
    create(:event)
    create(:venue)
    create(:organiser)

    skip_login(admin: true)

    click_on "Audit Log"

    expect(page).to have_content("Missing name create Event")
    expect(page).to have_content("Missing name create Venue")
    expect(page).to have_content("Missing name create Organiser")
  end

  context "when logged in as a non-admin" do
    it "does not allow access" do
      skip_login(admin: false)

      expect(page).to have_no_content("Audit Log")

      visit "/admin/audit_log"

      expect(page).to have_content("You are not authorised to view this page")
    end
  end
end

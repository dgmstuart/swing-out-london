# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can view an audit log" do
  it "showing a list of audited events" do
    stub_login

    visit "/login"
    click_button "Log in"

    create(:event)
    create(:venue)
    create(:organiser)

    ClimateControl.modify(AUDIT_LOG_PASSWORD: "pass") do
      visit "/audit_log?password=pass"
    end

    expect(page).to have_content("Audit Log")
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can create organisers" do
  it "with valid data" do
    skip_login(id: 12345678901234567, name: "Al Minns")

    click_on "New Organiser"

    fill_in "Name", with: "The London Swing Dance Society"
    fill_in "Shortname", with: "LSDS"
    fill_in "Description", with: "A long-running business"
    fill_in "Website", with: "http://www.lsds.co.uk"

    Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
      click_on "Create"
    end

    expect(page).to have_text("Name: The London Swing Dance Society")
      .and have_text("Shortname: LSDS")
      .and have_text("Description: A long-running business")
      .and have_text("Website: http://www.lsds.co.uk")

    expect(page).to have_text("Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
  end

  it "with an empty shortname" do
    skip_login("/organisers/new")

    fill_in "Name", with: "The London Swing Dance Society"
    fill_in "Shortname", with: ""

    click_on "Create"

    expect(page).to have_text("Last updated by")
  end

  context "with invalid data" do
    it "shows an error" do
      skip_login("/organisers/new")

      fill_in "Shortname", with: "12345678901234567890+"

      click_on "Create"

      expect(page).to have_text("2 errors prevented this record from being saved")
        .and have_text("Name can't be blank")
        .and have_text("Shortname is too long")

      fill_in "Name", with: "The London Swing Dance Society"
      fill_in "Shortname", with: "12345678901234567890"

      click_on "Create"

      expect(page).to have_text("Name: The London Swing Dance Society")
        .and have_text("Shortname: 12345678901234567890")
    end
  end
end

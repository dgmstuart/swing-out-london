# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can edit organisers" do
  it "with valid data" do
    stub_login(id: 12345678901234567, name: "Al Minns")
    create(
      :organiser,
      name: "The London Swing Dance Society",
      website: "https://www.lsds.co.uk",
      shortname: "lsds",
      description: "A long-running business"
    )

    visit "/login"
    click_on "Log in"

    click_on "Organisers"

    click_on "Edit", match: :first

    fill_in "Name", with: "Swingdance UK"
    fill_in "Shortname", with: ""
    fill_in "Website", with: "https://swingdanceuk.com"
    fill_in "Description", with: "A rebrand"

    Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
      click_on "Update"
    end

    expect(page).to have_content("Name: Swingdance UK")
      .and have_content("Shortname: Website") # ie. no value between this label and the next one
      .and have_content("Website: https://swingdanceuk.com")
      .and have_content("Description: A rebrand")

    expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
  end

  context "with invalid data" do
    it "shows an error" do
      organiser = create(
        :organiser,
        name: "The London Swing Dance Society",
        website: "https://www.lsds.co.uk",
        shortname: "lsds",
        description: "A long-running business"
      )
      skip_login

      visit "/organisers/#{organiser.to_param}/edit"

      fill_in "Name", with: ""
      fill_in "Shortname", with: "12345678901234567890+"

      click_on "Update"

      expect(page).to have_content("2 errors prevented this record from being saved")
        .and have_content("Name can't be blank")
        .and have_content("Shortname is too long")

      fill_in "Name", with: "Swingdance UK"
      fill_in "Shortname", with: "12345678901234567890"

      click_on "Update"

      expect(page).to have_content("Name: Swingdance UK")
        .and have_content("Shortname: 12345678901234567890")
    end
  end
end

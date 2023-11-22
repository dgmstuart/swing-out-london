# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can create venues" do
  it "with valid data", :vcr do
    stub_login(id: 12345678901234567, name: "Al Minns")

    visit "/login"
    click_button "Log in"

    click_link "New Venue"

    fill_in "Name", with: "The 100 Club"
    fill_in "Address", with: "100 Oxford Street\nLondon"
    fill_in "Postcode", with: "W1D 1LL"
    fill_in "Area", with: "Oxford Street"
    fill_in "Website", with: "https://www.the100club.co.uk/"
    Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
      VCR.use_cassette("geocode_100_club") do
        click_button "Create"
      end
    end

    expect(page).to have_content("Name: The 100 Club")
    expect(page).to have_content("Address: 100 Oxford Street\r London")
    expect(page).to have_content("Postcode: W1D 1LL")
    expect(page).to have_content("Area: Oxford Street")
    expect(page).to have_content("Website: https://www.the100club.co.uk/")
    expect(page.find("a", text: "https://www.the100club.co.uk/")["href"]).to eq("https://www.the100club.co.uk/")
    expect(page).to have_content("Coordinates: [ 51.5161046, -0.1353113 ]")
    expect(page.find("a", text: "[ 51.5161046, -0.1353113 ]")["href"])
      .to eq("https://www.google.co.uk/maps/place/51.5161046,-0.1353113/@51.5161046,-0.1353113,15z")

    expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
  end

  context "with invalid data" do
    it "shows an error" do
      skip_login

      visit "/venues/new"

      fill_in "Website", with: "www.the100club.co.uk"

      click_button "Create"

      expect(page).to have_content("5 errors prevented this record from being saved")
        .and have_content("Address can't be blank")
        .and have_content("Area can't be blank")
        .and have_content("Name can't be blank")
        .and have_content("Website is invalid")
        .and have_content("The address information could not be geocoded")

      fill_in "Name", with: "The 100 Club"
      fill_in "Address", with: "100 Oxford Street\nLondon"
      fill_in "Area", with: "Oxford Street"
      fill_in "Website", with: "https://www.the100club.co.uk/"
      fill_in "Latitude", with: "51.5164092"
      fill_in "Longitude", with: "-0.1345404"

      click_button "Create"

      expect(page).to have_content("Name: The 100 Club")
        .and have_content("Address: 100 Oxford Street\r London")
        .and have_content("Area: Oxford Street")
        .and have_content("Website: https://www.the100club.co.uk/")
        .and have_content("Coordinates: [ 51.5164092, -0.1345404 ]")
    end
  end
end

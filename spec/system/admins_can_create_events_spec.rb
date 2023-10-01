# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can create events", :js do
  context "an intermittent social with a taster" do # rubocop:disable RSpec/ContextWording
    it "with valid data" do
      stub_login(id: 12345678901234567, name: "Al Minns")
      create(:venue, name: "The 100 Club")
      create(:organiser, name: "The London Swing Dance Society")

      visit "/login"
      click_button "Log in with Facebook"

      click_link "New event", match: :first

      fill_in "Title", with: "Stompin'"
      autocomplete_select "The 100 Club", from: "Venue"
      autocomplete_select "The London Swing Dance Society", from: "Social organiser"
      autocomplete_select "The London Swing Dance Society", from: "Class organiser"
      check "Has a taster?"
      check "Has social?"
      choose "Other (balboa, shag etc)"
      fill_in "Dance style", with: "Balboa"
      fill_in "Course length", with: ""
      choose "Monthly or occasionally"
      fill_in "Upcoming dates", with: "12/12/2012, 19/12/2012"
      # TODO: Make this work:
      # fill_in 'Cancelled dates', with: '12/12/2012'
      fill_in "First date", with: ""
      fill_in "Url", with: "http://www.lsds.co.uk/stompin"

      Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
        click_button "Create"
      end

      expect(page).to have_content("Title:\nStompin'")
        .and have_content("Venue:\nThe 100 Club")
        .and have_content("Social Organiser:\nThe London Swing Dance Society")
        .and have_content("Class Organiser:\nThe London Swing Dance Society")
        .and have_content("Social with taster")
        .and have_content("Class style:\nBalboa")
        .and have_content("Frequency:\nMonthly or occasionally")
        .and have_content("Dates:\n12/12/2012, 19/12/2012")
        .and have_content("Cancelled:\nNone")
        .and have_content("First date:")
        .and have_content("Url:\nhttp://www.lsds.co.uk/stompin")

      expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
    end

    it "with missing data" do
      stub_login(id: 12345678901234567, name: "Al Minns")
      create(:venue, name: "The 100 Club")

      visit "/login"
      click_button "Log in with Facebook"

      click_link "New event", match: :first

      click_button "Create"

      expect(page).to have_content("4 errors prevented this record from being saved")
        .and have_content("Venue can't be blank")
        .and have_content("Url can't be blank")
        .and have_content("Frequency can't be blank")
        .and have_content("Events must have either a Social or a Class")

      autocomplete_select "The 100 Club", from: "Venue"
      check "Has social?"
      fill_in "Title", with: "Stompin'"
      choose "Weekly"
      select "Tuesday", from: "Day"
      fill_in "Url", with: "http://www.lsds.co.uk/stompin"

      click_button "Create"

      expect(page).to have_content("Venue:\nThe 100 Club")
        .and have_content("Social")
        .and have_content("Frequency:\nWeekly on Tuesdays")
        .and have_content("Url:\nhttp://www.lsds.co.uk/stompin")
    end

    it "from the 'New event at this venue' button" do
      create(:venue, name: "93 feet east", area: "Brick Lane")
      skip_login

      visit venues_path
      click_link "Show", match: :first

      expect(page).to have_content("93 feet east")

      click_link "New Event at this venue"

      expect(page).to have_content("New event")
      expect(page).to have_autocomplete_field("Venue", "93 feet east - Brick Lane")
    end
  end

  context "a weekly class" do # rubocop:disable RSpec/ContextWording
    it "with valid data" do
      stub_login(id: 12345678901234567, name: "Leon James")
      create(:venue, name: "Dogstar")
      create(:organiser, name: "Sunshine Swing")

      visit "/login"
      click_button "Log in with Facebook"

      click_link "New event", match: :first

      autocomplete_select "Dogstar", from: "Venue"
      autocomplete_select "Sunshine Swing", from: "Class organiser"
      check "Has a class?"
      choose "Weekly"
      select "Wednesday", from: "Day"
      fill_in "First date", with: "16/02/2000"
      fill_in "Url", with: "https://sunshineswing.uk/events"

      Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
        click_button "Create"
      end

      expect(page).to have_content("Venue:\nDogstar")
        .and have_content("Class Organiser:\nSunshine Swing")
        .and have_content("Class")
        .and have_content("Frequency:\nWeekly on Wednesdays")
        .and have_content("Cancelled:\nNone")
        .and have_content("First date:\nWednesday 16th February")
        .and have_content("Url:\nhttps://sunshineswing.uk/events")

      expect(page).to have_content("Last updated by Leon James (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
    end

    it "with missing data" do
      stub_login(id: 12345678901234567, name: "Leon James")
      create(:venue, name: "Dogstar")
      create(:organiser, name: "Sunshine Swing")

      visit "/login"
      click_button "Log in with Facebook"

      click_link "New event", match: :first

      click_button "Create"

      expect(page).to have_content("4 errors prevented this record from being saved")
        .and have_content("Venue can't be blank")
        .and have_content("Url can't be blank")
        .and have_content("Frequency can't be blank")
        .and have_content("Events must have either a Social or a Class")

      autocomplete_select "Dogstar", from: "Venue"
      check "Has a class?"
      choose "Weekly"
      select "Tuesday", from: "Day"
      fill_in "Url", with: "https://sunshineswing.uk/events"

      click_button "Create"

      expect(page).to have_content("1 error prevented this record from being saved")
        .and have_content("Class organiser must be present for classes")

      autocomplete_select "Sunshine Swing", from: "Class organiser"
      click_button "Create"

      expect(page).to have_content("Venue:\nDogstar")
        .and have_content("Class Organiser:\nSunshine Swing")
        .and have_content("Class")
        .and have_content("Frequency:\nWeekly on Tuesdays")
        .and have_content("Url:\nhttps://sunshineswing.uk/events")
    end
  end
end

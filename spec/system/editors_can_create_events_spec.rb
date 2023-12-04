# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can create events", :js do
  include ActiveSupport::Testing::TimeHelpers

  context "an intermittent social with a taster" do # rubocop:disable RSpec/ContextWording
    it "with valid data" do
      stub_login(id: 12345678901234567, name: "Al Minns")
      create(:venue, name: "The 100 Club")
      create(:organiser, name: "The London Swing Dance Society")

      visit "/login"
      click_button "Log in"

      click_link "New event", match: :first

      fill_in "Url", with: "http://www.lsds.co.uk/stompin"
      autocomplete_select "The 100 Club", from: "Venue"

      choose "Social dance" # Event Type
      fill_in "Title", with: "Stompin'"
      autocomplete_select "The London Swing Dance Society", from: "Social organiser"
      check "Has a class?"

      choose "Other (balboa, shag etc)"
      fill_in "Dance style", with: "Balboa"
      fill_in "Course length", with: ""
      # This autocomplete_select is above the other fields in the form, but
      # I guess it doesn't scroll the capybara page, so we need a simpler interaction first.
      autocomplete_select "The London Swing Dance Society", from: "Class organiser"

      choose "Monthly or occasionally"
      fill_in "Upcoming dates", with: "12/12/2012, 19/12/2012"
      fill_in "Cancelled dates", with: "12/12/2012"
      fill_in "First date", with: "12/12/2012"
      fill_in "Last date", with: "19/12/2012"

      Timecop.freeze(Time.zone.local(2012, 1, 2, 23, 17, 16)) do
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
        .and have_content("Cancelled:\n12/12/2012")
        .and have_content("First date:\nWednesday 12th December")
        .and have_content("Last date:\nWednesday 19th December")
        .and have_content("Url:\nhttp://www.lsds.co.uk/stompin")

      expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Monday 2nd January 2012 at 23:17:16")
    end

    it "with invalid data" do
      stub_login(id: 12345678901234567, name: "Al Minns")
      create(:venue, name: "The 100 Club")
      travel_to "2012-01-01"

      visit "/login"
      click_button "Log in"

      click_link "New event", match: :first

      click_button "Create"

      expect(page).to have_content("4 errors prevented this record from being saved")
        .and have_content("Venue can't be blank")
        .and have_content("Url can't be blank")
        .and have_content("Frequency can't be blank")
        .and have_content("Event type can't be blank")

      fill_in "Url", with: "http://www.lsds.co.uk/stompin"
      autocomplete_select "The 100 Club", from: "Venue"
      choose "Social dance"

      fill_in "Title", with: "Stompin'"

      choose "Monthly"
      fill_in "Upcoming dates", with: "12//20012, 31/04/2013, 12/12/2011,   19/12/012, 19/12/20121"

      click_button "Create"

      expect(page).to have_content("3 errors prevented this record from being saved")
        .and have_content('Dates contained some invalid dates: "12//20012", "31/04/2013"')
        .and have_content("Dates contained some dates in the past: 12/12/2011, 19/12/012")
        .and have_content("Dates contained some dates unreasonably far in the future: 19/12/20121")

      fill_in "Upcoming dates", with: "12/12/2012, 30/04/2013"
      fill_in "First date", with: "12/12/2012"
      fill_in "Last date", with: "30/04/2013"

      click_button "Create"

      expect(page).to have_content("Venue:\nThe 100 Club")
        .and have_content("Social")
        .and have_content("Frequency:\nMonthly or occasionally")
        .and have_content("Dates:\n12/12/2012, 30/04/2013")
        .and have_content("First date:\nWednesday 12th December")
        .and have_content("Last date:\nTuesday 30th April")
        .and have_content("Url:\nhttp://www.lsds.co.uk/stompin")
    end

    context "when switching from a class to a social" do
      it "doesn't save any values from the class" do
        create(:venue, name: "The 100 Club")
        create(:organiser, name: "The London Swing Dance Society")
        skip_login

        visit "/events/new"

        fill_in "Url", with: "http://www.lsds.co.uk/stompin"
        autocomplete_select "The 100 Club", from: "Venue"

        choose "Weekly class"

        autocomplete_select "The London Swing Dance Society", from: "Class organiser"
        choose "Other (balboa, shag etc)"
        fill_in "Dance style", with: "Balboa"
        fill_in "Course length", with: "6"

        # CHANGE OUR MINDS: It's actually a social
        choose "Social dance"
        fill_in "Title", with: "Stompin'"
        autocomplete_select "The London Swing Dance Society", from: "Social organiser"

        choose "Weekly"
        select "Wednesday", from: "Day"

        click_button "Create"

        event = Event.last
        aggregate_failures do
          expect(event.class_organiser).to be_nil
          expect(event.class_style).to eq ""
          expect(event.course_length).to be_nil
        end
      end
    end

    context "when switching from a social to a class" do
      it "doesn't save any values from the social" do
        create(:venue, name: "The 100 Club")
        create(:organiser, name: "The London Swing Dance Society")
        skip_login

        visit "/events/new"

        fill_in "Url", with: "http://www.lsds.co.uk/stompin"
        autocomplete_select "The 100 Club", from: "Venue"

        choose "Social dance"
        fill_in "Title", with: "Stompin'"
        autocomplete_select "The London Swing Dance Society", from: "Social organiser"

        # CHANGE OUR MINDS: It's actually a class
        choose "Weekly class"

        autocomplete_select "The London Swing Dance Society", from: "Class organiser"

        select "Wednesday", from: "Day"

        click_button "Create"

        event = Event.last
        aggregate_failures do
          expect(event.title).to be_nil
          expect(event.social_organiser).to be_nil
        end
      end
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
      click_button "Log in"

      click_link "New event", match: :first

      fill_in "Url", with: "https://sunshineswing.uk/events"
      autocomplete_select "Dogstar", from: "Venue"
      choose "Weekly class"

      autocomplete_select "Sunshine Swing", from: "Class organiser"

      select "Wednesday", from: "Day"
      fill_in "First date", with: "16/02/2000"
      fill_in "Last date", with: "16/02/2020"

      Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
        click_button "Create"
      end

      expect(page).to have_content("Venue:\nDogstar")
        .and have_content("Class Organiser:\nSunshine Swing")
        .and have_content("Class")
        .and have_content("Frequency:\nWeekly on Wednesdays")
        .and have_content("Cancelled:\nNone")
        .and have_content("First date:\nWednesday 16th February")
        .and have_content("Last date:\nSunday 16th February")
        .and have_content("Url:\nhttps://sunshineswing.uk/events")

      expect(page).to have_content("Last updated by Leon James (12345678901234567) on Sunday 2nd January 2000 at 23:17:16")
    end

    it "with missing data" do
      stub_login(id: 12345678901234567, name: "Leon James")
      create(:venue, name: "Dogstar")
      create(:organiser, name: "Sunshine Swing")

      visit "/login"
      click_button "Log in"

      click_link "New event", match: :first

      click_button "Create"

      expect(page).to have_content("4 errors prevented this record from being saved")
        .and have_content("Venue can't be blank")
        .and have_content("Url can't be blank")
        .and have_content("Frequency can't be blank")
        .and have_content("Event type can't be blank")

      autocomplete_select "Dogstar", from: "Venue"
      choose "Weekly class"

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

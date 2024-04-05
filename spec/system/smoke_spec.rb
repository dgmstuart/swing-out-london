# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Adding a new event", :js do
  around do |example|
    Timecop.freeze("01/01/1937T12:00") { example.run }
  end

  before { stub_const("DistantPastDateValidator::SOLDN_START_DATE", Date.parse("1926-03-12")) }

  it "with a social and a dance class" do
    stub_login
    visit "/events"

    click_on "Log in"

    # VENUE
    open_menu
    click_on "New Venue"

    fill_in "Name", with: "The Savoy Ballroom"
    fill_in "Address", with: "596 Lenox Avenue"
    fill_in "Postcode", with: "WC2R 0EZ"
    fill_in "Area", with: "Harlem"
    fill_in "Latitude", with: "40.817529"
    fill_in "Longitude", with: "73.938456"
    fill_in "Website", with: "https://www.savoyballroom.com"

    click_on "Create"

    expect(page).to have_no_content("error")

    # SOCIAL ORGANISER
    open_menu
    click_on "New Organiser"

    fill_in "Name", with: "Herbert White"
    fill_in "Shortname", with: "Whitey"
    fill_in "Website", with: "https://hoppingmainacs.org"
    fill_in "Description", with: "Architect of Whitey's Lindy Hoppers"

    click_on "Create"

    expect(page).to have_no_content("error")

    # CLASS ORGANISER
    open_menu
    click_on "New Organiser"

    fill_in "Name", with: "Frankie Manning"
    fill_in "Shortname", with: "Frankie"

    click_on "Create"

    expect(page).to have_no_content("error")

    # EVENT WITH CANCELLED DATE
    open_menu
    click_on "New Event"

    fill_in "Url", with: "https://www.savoyballroom.com/stompin"
    autocomplete_select "The Savoy Ballroom", from: "Venue"
    choose "Social dance"

    fill_in "Title", with: "Stompin at the Savoy"
    autocomplete_select "Herbert White", from: "Social organiser"

    check "Has a class?"
    autocomplete_select "Frankie Manning", from: "Class organiser"
    choose "Other (balboa, shag etc)"
    fill_in "Dance style", with: "Savoy Style"
    fill_in "Course length", with: ""

    choose "Weekly"
    select "Saturday", from: "Day"
    fill_in "Cancelled dates", with: "09/01/1937"
    fill_in "First date", with: "12/03/1926"
    fill_in "Last date", with: "01/01/1939" # the Savoy closed in 1958, but we only allow last dates to be set 2 years ahead

    click_on "Create"

    expect(page).to have_no_content("error")

    # RECENTLY STARTED EVENT (NEW!)
    open_menu
    click_on "New Event"

    fill_in "Url", with: "https://www.savoyballroom.com/ladies"
    autocomplete_select "The Savoy Ballroom", from: "Venue"
    choose "Social dance"

    fill_in "Title", with: "Ladies night"
    choose "Monthly or occasionally"

    fill_in "Upcoming dates", with: "01/01/1937,14/01/1937"
    fill_in "First date", with: "01/01/1937"

    click_on "Create"

    expect(page).to have_no_content("error")

    click_on "Swing Out London"

    venue_id = Venue.first.id

    expect(page).to have_no_content("error prevented this record from being saved")

    within "#social_dances" do
      rows = page.all(".date_row")
      within rows[0] do
        aggregate_failures do
          expect(page).to have_content "TODAY Friday 1st January"
          expect(page).to have_link "WC2R", href: "/map/socials/1937-01-01?venue_id=#{venue_id}"
          expect(page).to have_content "NEW! Ladies night"
          expect(page).to have_link "Ladies night - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/ladies"
        end
      end

      within rows[1] do
        aggregate_failures do
          expect(page).to have_content "TOMORROW Saturday 2nd January"
          expect(page).to have_link "WC2R", href: "/map/socials/1937-01-02?venue_id=#{venue_id}"
          expect(page).to have_link "Stompin at the Savoy - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/stompin"
        end
      end

      within rows[2] do
        aggregate_failures do
          expect(page).to have_content "Saturday 9th January"
          expect(page).to have_link "WC2R", href: "/map/socials/1937-01-09?venue_id=#{venue_id}"
          expect(page).to have_content "CANCELLED Stompin at the Savoy"
          # Regression: use .once to check that cancelled weekly events don't show twice
          expect(page).to have_content("Stompin at the Savoy").once
          expect(page).to have_link "Stompin at the Savoy - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/stompin"
        end
      end

      within rows[3] do
        aggregate_failures do
          expect(page).to have_content "Thursday 14th January"
          expect(page).to have_link "WC2R", href: "/map/socials/1937-01-14?venue_id=#{venue_id}"
          expect(page).to have_content "NEW! Ladies night"
          expect(page).to have_link "Ladies night - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/ladies"
        end
      end
    end

    within "#classes" do
      rows = page.all(".day_row")
      within rows[5] do
        aggregate_failures do
          expect(page).to have_content "Saturday"
          expect(page).to have_link "WC2R", href: "/map/classes/Saturday?venue_id=#{venue_id}"
          expect(page).to have_link "Harlem (Savoy Style) at Stompin at the Savoy with Frankie", href: "https://www.savoyballroom.com/stompin"
          expect(page).to have_content "Cancelled on 9th Jan"
        end
      end
    end

    expect(page).to have_no_content("<")
    expect(page).to have_no_content(">")
    expect(page).to have_no_content("abbr title=")

    aggregate_failures do
      expect(page).to have_css('meta[property="og:title"][content="Swing Out London"]', visible: :hidden)
      expect(page).to have_css('meta[property="og:description"][content*="Swing Out London is a listing"]', visible: :hidden)
      expect(page).to have_css('meta[property="og:url"][content="https://www.swingoutlondon.co.uk"]', visible: :hidden)
      expect(page).to have_css('meta[property="og:image"]', visible: :hidden)
      image_url = find('meta[property="og:image"]', visible: :hidden)["content"]
      image_url_regexp = %r{http://127\.0\.0\.1:\d+/assets/swingoutlondon_og-\h+\.png}
      expect(image_url).to match(image_url_regexp)
    end
  end
end

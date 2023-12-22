# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can edit events", :js do
  include ActiveSupport::Testing::TimeHelpers

  it "with valid data" do
    stub_login(id: 12345678901234567, name: "Al Minns")
    cancellations = ["01/10/2010", "02/12/2011"]
    create(:weekly_social, :with_class, class_style: "Balboa", first_date: "02/09/2010", cancellations:)
    create(:venue, name: "The 100 Club")
    create(:organiser, name: "The London Swing Dance Society")

    visit "/login"
    click_button "Log in"

    click_link "Edit", match: :first

    expect(page).to have_content("Event Type\nSocial dance")
    expect(page).to have_field("Cancelled dates", with: "01/10/2010,02/12/2011")

    fill_in "Url", with: "http://www.lsds.co.uk/stompin"
    autocomplete_select "The 100 Club", from: "Venue"

    fill_in "Title", with: "Stompin'"
    autocomplete_select "The London Swing Dance Society", from: "Social organiser"

    autocomplete_select "The London Swing Dance Society", from: "Class organiser"
    choose "Lindy Hop or general swing"
    fill_in "Course length", with: ""

    choose "Monthly or occasionally"
    fill_in "First date", with: "2010\t1010"
    fill_in "Last date", with: "2011\t1202"

    fill_in "Upcoming dates", with: "10/10/2010,10/11/2010, 02/12/2011"
    fill_in "Cancelled dates", with: "02/12/2011" # All cancellations need to be in the upcoming dates.

    Timecop.freeze(Time.zone.local(2010, 1, 2, 23, 17, 16)) do
      click_button "Update"
    end

    expect(page).to have_content("Title:\nStompin'")
      .and have_content("Venue:\nThe 100 Club")
      .and have_content("Social Organiser:\nThe London Swing Dance Society")
      .and have_content("Class Organiser:\nThe London Swing Dance Society")
      .and have_content("Social with taster")
      .and have_content("Class style:\nLindy Hop or general swing")
      .and have_content("Frequency:\nMonthly or occasionally")
      .and have_content("Dates:\n10/10/2010, 10/11/2010, 02/12/2011")
      .and have_content("Cancelled:\n02/12/2011")
      .and have_content("First date:\nSunday 10th October")
      .and have_content("Last date:\nFriday 2nd December")
      .and have_content("Url:\nhttp://www.lsds.co.uk/stompin")

    expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Saturday 2nd January 2010 at 23:17:16")
  end

  it "with invalid data" do
    stub_login(id: 12345678901234567, name: "Al Minns")
    create(:class)

    visit "/login"
    click_button "Log in"

    click_link "Edit", match: :first

    empty_autocomplete_field "Venue", "xyz"
    select "", from: "Day"
    fill_in "Url", with: ""

    click_button "Update"

    expect(page).to have_content("2 errors prevented this record from being saved:")
      .and have_content("Url can't be blank")
      .and have_content("Day must be present for weekly events")
  end

  it "adding dates" do
    create(:event, frequency: 0, dates: ["12/12/2012", "13/12/2012"])
    stub_login(id: 12345678901234567, name: "Al Minns")

    visit "/login"
    click_button "Log in"

    click_link "Edit", match: :first

    expect(page).to have_field("Upcoming dates", with: "12/12/2012,13/12/2012")

    fill_in "Upcoming dates", with: "12/12/2012, 12/01/2013"

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_button "Update"
    end

    expect(page).to have_content("Dates:\n12/12/2012, 12/01/2013")

    expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16")
    audit = Audit.last
    expect(audit.audited_changes).to eq("class_style" => [nil, ""])
    expect(audit.comment).to eq "Updated dates: (old: 12/12/2012,13/12/2012) (new: 12/12/2012,12/01/2013)"
  end

  it "adding invalid dates" do
    create(:event)
    stub_login
    travel_to "2023-11-05"

    visit "/login"
    click_button "Log in"

    click_link "Edit", match: :first

    fill_in "Upcoming dates", with: "12/12/2025, 03/11/2023"
    click_button "Update"

    expect(page).to have_content("1 error prevented this record from being saved")
      .and have_content("Dates contained some dates unreasonably far in the future: 12/12/2025")
  end

  it "adding cancellations to an occasional event" do
    create(:event, :occasional, dates: ["12/12/2012"])
    stub_login(id: 12345678901234567, name: "Al Minns")

    visit "/login"
    click_button "Log in"

    click_link "Edit", match: :first

    fill_in "Cancelled dates", with: "12/12/2012"

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_button "Update"
    end

    expect(page).to have_content("Cancelled:\n12/12/2012")

    expect(page).to have_content("Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16")
    audit = Audit.last
    expect(audit.audited_changes).to eq("class_style" => [nil, ""])
    expect(audit.comment).to eq "Updated cancellations: (old: ) (new: 12/12/2012)"
  end

  it "adding cancellations to a weekly event" do
    event = create(:event, :weekly)
    skip_login

    visit "/events/#{event.id}/edit"

    fill_in "Cancelled dates", with: "12/12/2012"

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_button "Update"
    end

    expect(page).to have_content("Cancelled:\n12/12/2012")
  end

  context "when changing from an occasional event to a weekly event" do
    it "removes any dates" do
      event_instances = [
        build(:event_instance, date: "12/11/2012", cancelled: true),
        build(:event_instance, date: "12/12/2012")
      ]
      event = create(:event, :occasional, event_instances:)

      skip_login

      visit edit_event_path(event)

      choose "Weekly"
      select "Thursday", from: "Day"

      click_button "Update"

      expect(page).not_to have_content("Dates")
      expect(page).to have_content("Cancelled:\n12/11/2012")
      expect(event.reload.dates).to be_empty
    end
  end

  context "when the event has an old frequency" do
    it "shows a message" do
      event = create(:event, frequency: 4)
      skip_login

      visit edit_event_path(event)

      expect(page).to have_content("Legacy frequency: 4")
    end
  end
end

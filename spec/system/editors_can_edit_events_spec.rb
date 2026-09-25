# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can edit events", :js do
  include ActiveSupport::Testing::TimeHelpers

  it "with valid data" do
    cancellations = ["01/10/2010", "02/12/2011"]
    create(:weekly_social, :with_class, class_style: "Balboa", first_date: "02/09/2010", cancellations:)
    create(:venue, name: "The 100 Club")
    create(:organiser, name: "The London Swing Dance Society")

    skip_login(id: 12345678901234567, name: "Al Minns")

    click_on "Edit", match: :first

    expect(page).to have_text("Event Type\nSocial dance")
    expect(page).to have_field("Cancelled dates", with: "01/10/2010,02/12/2011")

    fill_in "Url", with: "http://www.lsds.co.uk/stompin"
    autocomplete_select "The 100 Club", from: "Venue"

    fill_in "Title", with: "Stompin'"
    autocomplete_select "The London Swing Dance Society", from: "Social organiser"

    autocomplete_select "The London Swing Dance Society", from: "Class organiser"
    choose "Lindy Hop or general swing"
    fill_in "Course length", with: ""

    choose "Monthly or occasionally"
    fill_in "First date", with: "2010-10-10"
    fill_in "Last date", with: "2011-12-02"

    fill_in "Upcoming dates", with: "10/10/2010,10/11/2010, 02/12/2011"
    fill_in "Cancelled dates", with: "02/12/2011" # All cancellations need to be in the upcoming dates.

    Timecop.freeze(Time.zone.local(2010, 1, 2, 23, 17, 16)) do
      click_on "Update"

      expect(page).to have_text("Event was successfully updated")
    end

    expect(page).to have_text("Title:\nStompin'")
      .and have_text("Venue:\nThe 100 Club")
      .and have_text("Social Organiser:\nThe London Swing Dance Society")
      .and have_text("Class Organiser:\nThe London Swing Dance Society")
      .and have_text("Social with taster")
      .and have_text("Class style:\nLindy Hop or general swing")
      .and have_text("Frequency:\nMonthly or occasionally")
      .and have_text("Dates:\n10/10/2010, 10/11/2010, 02/12/2011")
      .and have_text("Cancelled:\n02/12/2011")
      .and have_text("First date:\n10/10/2010")
      .and have_text("Last date:\n02/12/2011")
      .and have_text("Url:\nhttp://www.lsds.co.uk/stompin")

    expect(page).to have_text("Last updated by Al Minns (12345678901234567) on Saturday 2nd January 2010 at 23:17:16")

    expect(page).to have_no_text("Activity")

    # view the page as an admin:
    skip_login(page.current_path, admin: true)

    expect(page).to have_text("Activity")
    expect(page).to have_text("[2010-01-02 23:17:16] Al Minns update")
  end

  it "with invalid data" do
    create(:class)

    skip_login

    click_on "Edit", match: :first

    empty_autocomplete_field "Venue", "xyz"
    select "", from: "Day"
    fill_in "Url", with: ""

    click_on "Update"

    expect(page).to have_text("2 errors prevented this record from being saved:")
      .and have_text("Url can't be blank")
      .and have_text("Day must be present for weekly events")
  end

  it "adding dates" do
    create(:event, frequency: 0, dates: ["12/12/2012", "13/12/2012"])

    skip_login(id: 12345678901234567, name: "Al Minns")

    click_on "Edit", match: :first

    expect(page).to have_field("Upcoming dates", with: "12/12/2012,13/12/2012")

    fill_in "Upcoming dates", with: "12/12/2012, 12/01/2013"

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_on "Update"

      expect(page).to have_text("Event was successfully updated")
    end

    expect(page).to have_text("Dates:\n12/12/2012, 12/01/2013")

    expect(page).to have_text("Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16")
    audit = Audit.last
    expect(audit.audited_changes).to eq("class_style" => [nil, ""])
    expect(audit.comment).to eq "Updated dates: (old: 12/12/2012,13/12/2012) (new: 12/12/2012,12/01/2013)"
  end

  it "adding invalid dates" do
    create(:event)
    travel_to "2023-11-05"

    skip_login

    click_on "Edit", match: :first

    fill_in "Upcoming dates", with: "12/12/2025, 03/11/2023"
    click_on "Update"

    expect(page).to have_text("1 error prevented this record from being saved")
      .and have_text("Dates contained some dates unreasonably far in the future: 12/12/2025")
  end

  it "adding cancellations to an occasional event" do
    create(:event, :occasional, dates: ["12/12/2012"])

    skip_login(id: 12345678901234567, name: "Al Minns")

    click_on "Edit", match: :first

    fill_in "Cancelled dates", with: "12/12/2012"

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_on "Update"

      expect(page).to have_text("Event was successfully updated")
    end

    expect(page).to have_text("Cancelled:\n12/12/2012")
    expect(page).to have_text("Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16")
    audit = Audit.last
    expect(audit.audited_changes).to eq("class_style" => [nil, ""])
    expect(audit.comment).to eq "Updated cancellations: (old: ) (new: 12/12/2012)"
  end

  it "adding cancellations to a weekly event" do
    event = create(:event, :weekly)

    skip_login("/events/#{event.id}/edit")

    fill_in "Cancelled dates", with: "12/12/2012"

    click_on "Update"

    expect(page).to have_text("Cancelled:\n12/12/2012")
  end

  context "when changing from an occasional event to a weekly event" do
    it "removes any dates" do
      event_instances = [
        build(:event_instance, date: "12/11/2012", cancelled: true),
        build(:event_instance, date: "12/12/2012")
      ]
      event = create(:event, :occasional, event_instances:)

      skip_login(edit_event_path(event))

      choose "Weekly"
      select "Thursday", from: "Day"

      click_on "Update"

      expect(page).to have_no_text("Dates")
      expect(page).to have_text("Cancelled:\n12/11/2012")
      expect(event.reload.dates).to be_empty
    end
  end

  context "when the event is a weekly class" do
    it "doesn't allow the frequency to be edited" do
      event = create(:class)

      skip_login(edit_event_path(event))

      aggregate_failures do
        expect(page).to have_no_text("Monthly")
        expect(page).to have_no_text("occasionally")
        expect(page).to have_no_text("Upcoming dates")
      end
    end
  end

  context "when the event has an old frequency" do
    it "shows a message" do
      event = create(:event, frequency: 4)

      skip_login(edit_event_path(event))

      expect(page).to have_text("Legacy frequency: 4")
    end
  end
end

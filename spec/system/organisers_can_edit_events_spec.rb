# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Organisers can edit events" do
  include ActiveSupport::Testing::TimeHelpers

  context "when an organiser token exists", :js do
    it "allows an organiser to edit an occasional event" do
      create(
        :social,
        organiser_token: "abc123",
        title: "Midtown stomp",
        url: "https://www.swingland.com/midtown",
        frequency: 0,
        first_date: Date.new(2001, 2, 3),
        event_instances: [build(:event_instance, date: "12/12/2012")]
      )
      travel_to("2013-01-01")

      create(:venue, name: "The 100 Club", area: "central")

      visit("/external_events/abc123/edit")

      expect(page).to have_content("Midtown stomp")
        .and have_link("https://www.swingland.com/midtown", href: "https://www.swingland.com/midtown")
        .and have_content("Frequency\nOccasional")
        .and have_content("Status\nNot listed (no future dates)")

      autocomplete_select "The 100 Club", from: "Venue"
      fill_in "Upcoming dates", with: "12/12/2012, 12/01/2013"
      fill_in "Cancelled dates", with: "12/12/2012"
      click_on "Update"

      expect(page).to have_content("Event was successfully updated")
        .and have_content("Status\nWill be listed until 12/01/2013")

      aggregate_failures do
        expect(page).to have_field("Venue", with: "The 100 Club - central")
        expect(page).to have_field("Upcoming dates", with: "12/12/2012,12/01/2013")
        expect(page).to have_field("Cancelled dates", with: "12/12/2012")
        expect(page).to have_content("Event was successfully updated")
      end

      expect(Audit.last.username).to eq("name" => "Organiser", "auth_id" => "abc123")
    end

    it "allows an organiser to edit a weekly event", :js do
      create(
        :social,
        organiser_token: "abc123",
        title: "Midtown stomp",
        url: "https://www.swingland.com/midtown",
        day: "Wednesday",
        frequency: 1,
        first_date: Date.new(2001, 2, 3)
      )
      create(:venue, name: "The 100 Club", area: "central")

      visit("/external_events/abc123/edit")

      expect(page).to have_content("Midtown stomp")
        .and have_link("https://www.swingland.com/midtown", href: "https://www.swingland.com/midtown")
        .and have_content("Frequency\nEvery Wednesday")
      expect(page).to have_no_content("Upcoming dates")

      autocomplete_select "The 100 Club", from: "Venue"
      fill_in "Cancelled dates", with: "12/12/2012"
      fill_in "Last date", with: "12/01/2013"
      click_on "Update"

      expect(page).to have_content("Event was successfully updated")

      aggregate_failures do
        expect(page).to have_field("Venue", with: "The 100 Club - central")
        expect(page).to have_no_content("Upcoming dates")
        expect(page).to have_field("Cancelled dates", with: "12/12/2012")
        expect(page).to have_field("Last date", with: "2013-01-12")
        expect(page).to have_content("Event was successfully updated")
      end

      expect(Audit.last.username).to eq("name" => "Organiser", "auth_id" => "abc123")
    end

    it "allows an organiser to cancel their changes", :js do
      create(
        :social,
        venue: build(:venue, name: "The Bishopsgate Centre", area: "Liverpool st"),
        organiser_token: "abc123",
        title: "Midtown stomp",
        url: "https://www.swingland.com/midtown",
        frequency: 0,
        dates: ["01/02/2036"],
        first_date: Date.new(2001, 2, 3)
      )
      create(:venue, name: "The 100 Club", area: "central")

      visit("/external_events/abc123/edit")

      autocomplete_select "The 100 Club", from: "Venue"
      fill_in "Upcoming dates", with: "12/12/2012, 12/01/2013"
      fill_in "Cancelled dates", with: "12/12/2012"

      click_on "Cancel"

      aggregate_failures do
        expect(page).to have_field("Venue", with: "The Bishopsgate Centre - Liverpool st")
        expect(page).to have_field("Upcoming dates", with: "01/02/2036")
        expect(page).to have_field("Cancelled dates", with: "")
      end
    end

    context "when the event is occasional but a last date has already been set" do
      it "allows an organiser to remove it" do
        create(
          :social,
          organiser_token: "abc123",
          frequency: 0,
          last_date: Date.new(2013, 1, 12),
          event_instances: [build(:event_instance, date: "12/12/2012")]
        )
        travel_to("2013-01-01")

        visit("/external_events/abc123/edit")

        expect(page).to have_field("Last date", with: "2013-01-12")

        fill_in "Last date", with: ""
        click_on "Update"

        aggregate_failures do
          expect(page).to have_content("Event was successfully updated")
          expect(page).to have_no_content("Last date")
        end
      end
    end

    it "shows a sensible title for classes" do
      organiser = create(:organiser, name: "Herbert White")
      create(:class, organiser_token: "abc123", class_organiser: organiser)

      visit("/external_events/abc123/edit")

      expect(page).to have_content("Dance class by Herbert White")
    end

    it "does not allow organisers to access other pages" do
      event = create(:social, organiser_token: "abc123", title: "Midtown stomp")

      visit("/external_events/abc123/edit")

      expect(page).to have_content("Midtown stomp")

      visit("/events/#{event.id}/edit")

      expect(page).to have_button("Log in")
    end
  end

  context "when the changes are invalid" do
    it "shows validation errors" do
      create(:social, organiser_token: "abc123")

      visit("/external_events/abc123/edit")

      select "", from: "Venue"
      click_on "Update"

      expect(page).to have_content("1 error prevented this record from being saved:")
        .and have_content("Venue can't be blank")
    end
  end

  context "when the cancellation dates are past the last date [REGRESSION]" do
    it "shows validation errors" do
      create(:class, organiser_token: "abc123")

      visit("/external_events/abc123/edit")

      fill_in "Cancelled dates", with: "29/09/2025"
      fill_in "Last date", with: "2025-09-27"
      click_on "Update"

      expect(page).to have_content("1 error prevented this record from being saved:")
        .and have_content("Cancellations can't include dates after the last date")
    end
  end

  context "when the organiser token is incorrect" do
    it "renders a 404" do
      visit("/external_events/abc123/edit")

      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end

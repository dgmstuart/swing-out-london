# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can put events on hiatus", :js do
  context "when the event is a weekly social" do
    it "with a valid date range" do
      create(:weekly_social, day: "Monday", title: "Camberwell Bounce")

      skip_login

      Timecop.freeze(Date.parse("2012-06-01")) do
        click_on "Edit", match: :first

        choose "This event is taking a break"
        fill_in "Start of break", with: "25/06/2012"
        fill_in "First date back after the break", with: "20/08/2012"

        click_on "Update"

        expect(page).to have_content("Event was successfully updated")

        click_on "Edit"

        expect(page).to have_checked_field("event[status]", with: "taking_a_break")
        expect(page).to have_field("Start of break", with: "2012-06-25")
        expect(page).to have_field("First date back after the break", with: "2012-08-20")

        visit("/")

        expect(page).to have_content("Camberwell Bounce").twice
      end

      Timecop.freeze(Date.parse("2012-06-17")) do
        visit("/")

        expect(page).to have_content("Camberwell Bounce").once # 25th Jun isn't shown
        expect(page).to have_content("Monday 18th June").once
      end

      Timecop.freeze(Date.parse("2012-07-01")) do
        visit("/")

        expect(page).not_to have_content("Camberwell Bounce").once # no dates in July
      end

      Timecop.freeze(Date.parse("2012-08-10")) do
        visit("/")

        expect(page).to have_content("Camberwell Bounce").once # 13th Aug isn't shown
        expect(page).to have_content("Monday 20th August").once
      end
    end
  end
end

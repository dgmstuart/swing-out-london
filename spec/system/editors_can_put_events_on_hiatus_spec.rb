# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can put events on hiatus", :js do
  context "when the event is a weekly social" do
    it "with a valid date range" do
      create(:weekly_social, day: "Monday")

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
      end
    end
  end
end

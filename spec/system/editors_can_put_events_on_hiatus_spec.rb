# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can put events on hiatus", :js do
  context "when the event is a weekly social" do
    it "with a valid date range" do
      create(:weekly_social, day: "Monday")

      skip_login

      click_on "Edit", match: :first

      choose "This event is taking a break"
      fill_in "Start of break", with: "2010-06-28"
      fill_in "First date back after the break", with: "2010-08-30"

      Timecop.freeze(Date.parse("2010-06-01")) do
        click_on "Update"

        expect(page).to have_content("Event was successfully updated")
      end

      expect(page).to have_content("On hiatus:\nFrom 28/06/2010, returning 30/08/2010")

      visit("/")

      save_and_open_page
    end
  end
end

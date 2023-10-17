# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can delete venues" do
  context "when the venue has no associated events", :js do
    it "can be deleted from the venue list" do
      stub_login
      create(:venue, name: "Bobby McGee's")

      visit "/login"
      click_button "Log in"

      click_link "Venues", match: :first

      accept_confirm do
        click_link "Delete", match: :first
      end

      expect(page).to have_content("Listing venues")
      expect(page).not_to have_content("Delete")
      expect(page).not_to have_content("Bobby McGee's")
    end

    it "can be deleted from the edit page" do
      stub_login
      create(:venue, name: "Bobby McGee's")

      visit "/login"
      click_button "Log in"

      click_link "Venues", match: :first

      click_link "Edit", match: :first

      accept_confirm do
        click_link "Delete"
      end

      expect(page).to have_content("Listing venues")
      expect(page).not_to have_content("Delete")
      expect(page).not_to have_content("Bobby McGee's")
    end
  end

  context "when the venue has associated events" do
    it "cannot be deleted" do
      stub_login
      venue = create(:venue)
      create(:event, venue:)

      visit "/login"
      click_button "Log in"

      click_link "Venues", match: :first

      expect(page).not_to have_content("Delete")

      click_link "Show"

      expect(page).not_to have_content("Delete")

      click_link "Edit"

      expect(page).not_to have_content("Delete")
      expect(page).to have_content("Can't be deleted: has associated events")
    end
  end
end

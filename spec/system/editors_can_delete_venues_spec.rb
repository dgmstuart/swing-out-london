# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can delete venues" do
  context "when the venue has no associated events", :js do
    it "can be deleted from the venue list" do
      create(:venue, name: "Bobby McGee's")

      skip_login("/venues")

      accept_confirm do
        click_on "Delete", match: :first
      end

      expect(page).to have_content("Listing venues")
      expect(page).to have_no_content("Delete")
      expect(page).to have_no_content("Bobby McGee's")
    end

    it "can be deleted from the edit page" do
      create(:venue, name: "Bobby McGee's")

      skip_login("/venues")

      click_on "Edit", match: :first

      accept_confirm do
        click_on "Delete"
      end

      expect(page).to have_content("Listing venues")
      expect(page).to have_no_content("Delete")
      expect(page).to have_no_content("Bobby McGee's")
    end
  end

  context "when the venue has associated events" do
    it "cannot be deleted" do
      stub_login
      venue = create(:venue)
      create(:event, venue:)

      skip_login("/venues")

      click_on "Venues", match: :first

      expect(page).to have_no_content("Delete")

      click_on "Show"

      expect(page).to have_no_content("Delete")

      click_on "Edit"

      expect(page).to have_no_content("Delete")
      expect(page).to have_content("Can't be deleted: has associated events")
    end
  end
end

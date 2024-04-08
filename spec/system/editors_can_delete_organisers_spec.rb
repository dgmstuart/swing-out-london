# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can delete organisers" do
  context "when the organiser has no associated events", :js do
    it "can be deleted from the organiser list" do
      create(:organiser, name: "Herbert White")

      skip_login("/organisers")

      accept_confirm do
        click_on "Delete", match: :first
      end

      expect(page).to have_content("Listing organisers")
      expect(page).to have_no_content("Delete")
      expect(page).to have_no_content("Herbert White")
    end

    it "can be deleted from the edit page" do
      create(:organiser, name: "Herbert White")

      skip_login("/organisers")

      click_on "Edit", match: :first

      accept_confirm do
        click_on "Delete"
      end

      expect(page).to have_content("Listing organisers")
      expect(page).to have_no_content("Delete")
      expect(page).to have_no_content("Herbert White")
    end
  end

  context "when the organiser has associated events" do
    it "cannot be deleted" do
      organiser = create(:organiser)
      create(:event, social_organiser: organiser)

      skip_login("/organisers")

      expect(page).to have_no_content("Delete")

      click_on "Show"

      expect(page).to have_no_content("Delete")

      click_on "Edit"

      expect(page).to have_no_content("Delete")
      expect(page).to have_content("Can't be deleted: has associated events")
    end
  end
end

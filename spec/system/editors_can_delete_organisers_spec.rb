# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can delete organisers" do
  context "when the organiser has no associated events", :js do
    it "can be deleted from the organiser list" do
      stub_login
      create(:organiser, name: "Herbert White")

      visit "/login"
      click_on "Log in"

      open_menu
      click_on "Organisers", match: :first

      accept_confirm do
        click_on "Delete", match: :first
      end

      expect(page).to have_content("Listing organisers")
      expect(page).to have_no_content("Delete")
      expect(page).to have_no_content("Herbert White")
    end

    it "can be deleted from the edit page" do
      stub_login
      create(:organiser, name: "Herbert White")

      visit "/login"
      click_on "Log in"

      open_menu
      click_on "Organisers", match: :first

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
      stub_login
      organiser = create(:organiser)
      create(:event, social_organiser: organiser)

      visit "/login"
      click_on "Log in"

      open_menu
      click_on "Organisers", match: :first

      expect(page).to have_no_content("Delete")

      click_on "Show"

      expect(page).to have_no_content("Delete")

      click_on "Edit"

      expect(page).to have_no_content("Delete")
      expect(page).to have_content("Can't be deleted: has associated events")
    end
  end
end

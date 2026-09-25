# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can delete events" do
  it "can be deleted from the event list", :js do
    create(:event, title: "Balboa at Bobby McGee's")

    skip_login

    # The delete link only shows above 900px wide
    page.driver.browser.manage.window.resize_to(901, 600)

    accept_confirm do
      click_on "Delete", match: :first
    end

    expect(page).to have_text("Event Name")
    expect(page).to have_no_text("Delete")
    expect(page).to have_no_text("Balboa at Bobby McGee's")
  end
end

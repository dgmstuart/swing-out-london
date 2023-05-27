# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can delete events" do
  it "can be deleted from the event list", :js do
    stub_login
    create(:event, title: "Balboa at Bobby McGee's")

    visit "/login"
    click_on "Log in with Facebook"

    # The delete link only shows above 900px wide
    page.driver.browser.manage.window.resize_to(901, 600)

    accept_confirm do
      click_on "Delete", match: :first
    end

    expect(page).to have_content("Event Name")
    expect(page).not_to have_content("Delete")
    expect(page).not_to have_content("Balboa at Bobby McGee's")
  end
end

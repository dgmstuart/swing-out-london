# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can navigate" do
  it "from a show page to an edit page" do
    stub_login
    create(:event, url: "https://navigating.se")

    visit "/login"
    click_on "Log in"

    click_on "Show", match: :first

    click_on "Edit"

    expect(page).to have_content("Editing event")
  end
end

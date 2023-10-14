# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users can see Info pages" do
  it "Users can see an about page" do
    visit "/"
    within "#main_nav" do
      click_link "About"
    end

    expect(page).to have_content("About Swing Out London")
  end

  it "Users can see a listings policy" do
    visit "/"
    within "#main_nav" do
      click_link "Listings Policy"
    end

    expect(page).to have_content("Location")
      .and have_content("swingoutlondon@gmail.com")
  end
end
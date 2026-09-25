# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users can see Info pages" do
  it "Users can see an about page" do
    visit "/"
    within "#main_nav" do
      click_on "About"
    end

    expect(page).to have_text("About Swing Out London")
  end

  it "Users can see a listings policy" do
    visit "/"
    within "#main_nav" do
      click_on "Listings Policy"
    end

    expect(page).to have_text("Location")
      .and have_text("swingoutlondon@gmail.com")
  end

  context "when the city is Bristol" do
    before { stub_const("CITY", City.build_bristol) }

    it "Users can see an about page" do
      visit "/"
      within "#main_nav" do
        click_on "About"
      end

      expect(page).to have_text("About Swing Out Bristol")
    end

    it "Users can see a listings policy" do
      visit "/"
      within "#main_nav" do
        click_on "Listings Policy"
      end

      expect(page).to have_text("Location")
        .and have_text("swingoutbristol@gmail.com")
    end
  end
end

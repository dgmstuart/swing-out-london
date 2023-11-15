# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users can view a map of upcoming events" do
  describe "socials page" do
    it "viewing the page" do
      event_instances = [
        build(:event_instance, date: "2019-06-08"),
        build(:event_instance, date: "2019-06-17", cancelled: true)
      ]
      create(
        :social,
        venue: build(
          :venue,
          name: "The Boudoir Club",
          address: "22 Night Street",
          postcode: "ZZ2 2ZZ"
        ),
        title: "Bedroom Bounce",
        url: "https://bb.com",
        event_instances:,
        first_date: Date.new(2019, 6, 8),
        has_taster: true,
        class_style: "Balboa"
      )

      create(
        :social,
        :weekly,
        day: "Thursday",
        venue: build(
          :venue,
          name: "The Alhambra",
          address: "17-19 Argyle St, London",
          postcode: "WC1H 8EJ"
        ),
        title: "Alhambra Thursdays",
        url: "https://at.com",
        has_class: true,
        class_organiser: create(:organiser, name: "Ann Johnson")
      )

      Timecop.freeze(Time.utc(2019, 6, 4, 12)) do
        visit "/map/socials"
      end

      expect(page).to have_content("Tuesday 4th June")
        .and have_content("Wednesday 5th June")
        .and have_content("Thursday 6th June")
        .and have_content("Friday 7th June")
        .and have_content("Saturday 8th June")
        .and have_content("Sunday 9th June")
        .and have_content("Monday 10th June")
        .and have_content("Tuesday 11th June")
        .and have_content("Wednesday 12th June")
        .and have_content("Thursday 13th June")
        .and have_content("Friday 14th June")
        .and have_content("Saturday 15th June")
        .and have_content("Sunday 16th June")
        .and have_content("Monday 17th June")

      marker_json = page.find_by_id("map")["data-markers"]
      markers = JSON.parse(marker_json)
      expect(markers.count).to eq 2

      info_window_string = markers.first.fetch("infoWindowContent")
      info_window = Capybara.string(info_window_string)
      aggregate_failures do
        expect(info_window).to have_content("The Alhambra")
        expect(info_window).to have_content("17-19 Argyle St")
        expect(info_window).to have_content("WC1H 8EJ")
        expect(info_window).to have_content("Thursday 6th June:")
        expect(info_window).to have_content("Thursday 13th June:")
        expect(info_window).to have_content("Alhambra Thursdays (class by Ann Johnson)").twice
        expect(info_window).to have_link("Alhambra Thursdays", href: "https://at.com").twice
      end

      info_window_string = markers.last.fetch("infoWindowContent")
      info_window = Capybara.string(info_window_string)
      aggregate_failures do
        expect(info_window).to have_content("The Boudoir Club")
        expect(info_window).to have_content("22 Night Street")
        expect(info_window).to have_content("ZZ2 2ZZ")
        expect(info_window).to have_content("Saturday 8th June:")
        expect(info_window).to have_content(/Monday 17th June:\s+Cancelled/)
        expect(info_window).to have_content("New! Bedroom Bounce (Balboa taster)").twice
        expect(info_window).to have_link("Bedroom Bounce", href: "https://bb.com").twice
      end
    end

    context "when a date in the past is requested" do
      it "redirects to the main socials view" do
        visit "/map/socials/2015-12-25"

        expect(page).to have_content("Swing Out London")
        expect(page).to have_content("Lindy Map")
        expect(page).to have_current_path("/map/socials")
      end
    end

    context "when a social has no title (regression test)" do
      # TODO: delete this and the related functionality when all records have been fixed on production.
      it "silently doesn't render it" do
        social = create(:social, dates: [Date.new(2019, 6, 8)])
        social.update_attribute(:title, nil) # rubocop:disable Rails/SkipsModelValidations

        Timecop.freeze(Time.utc(2019, 6, 4, 12)) do
          expect do
            visit "/map/socials"
          end.not_to raise_error
        end
      end
    end

    it "viewing the map by clicking a postcode" do
      venue = create(:venue, postcode: "ZZ2 2ZZ")
      create(:weekly_social, venue:)

      visit "/"

      first(:link, "ZZ2 2ZZ").click

      expect(page).to have_content("Lindy Map")
    end
  end

  describe "classes page" do
    it "viewing the page" do
      venue = create(
        :venue,
        name: "The Daylight Centre",
        address: "9 Mornington Crescent",
        postcode: "DA7 1GH"
      )
      organiser = create(:organiser, name: "Morning Swing")
      create(
        :class,
        venue:,
        class_organiser: organiser,
        class_style: "Balboa",
        url: "https://dlc.com",
        day: "Wednesday"
      )

      visit "/map/classes"

      expect(page).to have_content("Monday")
        .and have_content("Tuesday")
        .and have_content("Wednesday")
        .and have_content("Thursday")
        .and have_content("Friday")
        .and have_content("Saturday")
        .and have_content("Sunday")

      marker_json = page.find_by_id("map")["data-markers"]
      markers = JSON.parse(marker_json)
      expect(markers.count).to eq 1
      info_window_string = markers.first.fetch("infoWindowContent")
      info_window = Capybara.string(info_window_string)
      expect(info_window).to have_content("The Daylight Centre")
      expect(info_window).to have_content("9 Mornington Crescent")
      expect(info_window).to have_content("DA7 1GH")
      expect(info_window).to have_content("Wednesdays")
      expect(info_window).to have_link("Class (Balboa) with Morning Swing", href: "https://dlc.com")
    end

    context "when the day is misspelled" do
      it "redirects to the main classes view" do
        visit "/map/classes/mOoonday"

        expect(page).to have_content("Swing Out London")
        expect(page).to have_content("Lindy Map")
        expect(page).to have_current_path("/map/classes")
      end
    end

    it "viewing the map by clicking a postcode" do
      venue = create(:venue, postcode: "ZZ2 2ZZ")
      create(:class, venue:)

      visit "/"

      click_link("ZZ2 2ZZ")

      expect(page).to have_content("Lindy Map")
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can list occasional events" do
  it "with a dance class" do
    venue = create(
      :venue,
      name: "The Savoy Ballroom",
      postcode: "WC2R 0EZ",
      area: "Harlem"
    )
    social_organiser = create(:organiser)
    class_organiser = create(
      :organiser,
      shortname: "Frankie"
    )
    Timecop.freeze("01/01/1937") do
      event = create(
        :event,
        title: "Stompin at the Savoy",
        venue:,
        social_organiser:,
        class_organiser:,
        has_taster: false,
        has_class: true,
        has_social: true,
        class_style: "Savoy Style",
        course_length: "",
        day: "Saturday",
        frequency: 0,
        dates: [Date.parse("02/01/1937"), Date.parse("09/01/1937"), Date.parse("6/2/1937")],
        first_date: Date.parse("12/03/1926"),
        last_date: Date.parse("11/10/1958"),
        url: "https://www.savoyballroom.com/stompin"
      )
      event.update!(cancellations: [Date.parse("09/01/1937")])
    end

    Timecop.freeze("02/01/1937") do
      skip_login
      visit "/occasional"
    end

    within "section.listings" do
      within page.all(".date_row")[0] do
        expect(page).to have_content "Saturday 2nd January"
        expect(page).to have_content "WC2R"
        expect(page).to have_link "Stompin at the Savoy - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/stompin"
      end

      within page.all(".date_row")[1] do
        expect(page).to have_content "Saturday 9th January"
        expect(page).to have_content "WC2R"
        expect(page).to have_link "Stompin at the Savoy - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/stompin"
        expect(page).to have_content "Cancelled Stompin at the Savoy"
      end

      within page.all(".date_row")[2] do
        expect(page).to have_content "Saturday 6th February"
        expect(page).to have_content "WC2R"
        expect(page).to have_link "Stompin at the Savoy - The Savoy Ballroom in Harlem", href: "https://www.savoyballroom.com/stompin"
      end
    end
  end
end

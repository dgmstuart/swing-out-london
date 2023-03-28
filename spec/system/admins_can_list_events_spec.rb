# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can list events" do
  include ActiveSupport::Testing::TimeHelpers

  it "shows a list of events" do
    # stub_login(id: 12345678901234567, name: 'Al Minns')

    Timecop.freeze(Time.zone.local(1997, 5, 23)) do
      create(
        :event,
        title: "Stompin'",
        venue: create(:venue, name: "The 100 Club", area: "Oxford Street"),
        class_organiser: create(:organiser, name: "Simon Selmon"),
        social_organiser: create(:organiser, name: "The London Swing Dance Society"),
        day: "Monday",
        frequency: 0,
        dates: [Date.new(1997, 6, 1), Date.new(1997, 7, 5)]
      )
    end

    visit "/login"
    click_on "Log in with Facebook"

    expect(page).to have_content("Stompin\'")
      .and have_content("The 100 Club")
      .and have_content("Oxford Street")
      .and have_content("Simon Selmon")
      .and have_content("The London Swing Dance Society")
      .and have_content("Mon")
      .and have_content(0)
      .and have_content("01/06/1997, 05/07/1997")
  end

  it "notes when an event has ended" do
    travel_to("1st May 1935".to_date)
    create(
      :event,
      frequency: 1,
      last_date: "20th May 1935".to_date
    )

    skip_login
    visit "/events"

    expect(page).to have_content("Ended")
  end
end

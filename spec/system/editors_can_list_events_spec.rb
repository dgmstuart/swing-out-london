# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Editors can list events" do
  include ActiveSupport::Testing::TimeHelpers

  it "shows a list of events" do
    Timecop.freeze(Time.zone.local(2012, 5, 23)) do
      create(
        :event,
        title: "Stompin'",
        venue: create(:venue, name: "The 100 Club", area: "Oxford Street"),
        class_organiser: create(:organiser, name: "Simon Selmon"),
        social_organiser: create(:organiser, name: "The London Swing Dance Society"),
        frequency: 0,
        dates: [Date.new(2012, 6, 1), Date.new(2012, 7, 5)]
      )
    end

    skip_login

    expect(page).to have_text("Stompin'")
      .and have_text("The 100 Club")
      .and have_text("Oxford Street")
      .and have_text("Simon Selmon")
      .and have_text("The London Swing Dance Society")
      .and have_text(0)
      .and have_text("05/07/2012, 01/06/2012")
  end

  it "notes when an event has ended" do
    travel_to("20th May 1935".to_date)
    create(
      :weekly_social,
      last_date: "1st May 1935".to_date
    )

    skip_login

    expect(page).to have_text("Ended")
  end
end

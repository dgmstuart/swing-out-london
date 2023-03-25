# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admins can see associated events on venues" do
  it "when there are associated events" do
    stub_login
    venue = create(:venue)
    organiser = create(:organiser, name: "Ron and Christine")
    dance_class = create(:class, class_organiser: organiser, day: "Wednesday", venue: venue)
    social = create(:social, title: "The Sunday Stomp", venue: venue)

    visit "/login"
    click_on "Log in with Facebook"

    click_on "Venues"

    click_on "Show"

    expect(page).to have_content("Associated Events")
    expect(page).to have_link("Class with Ron and Christine on Wednesdays", href: event_path(dance_class))
    expect(page).to have_link("Social: The Sunday Stomp", href: event_path(social))
  end

  it "when there are no associated events" do
    stub_login
    create(:venue)

    visit "/login"
    click_on "Log in with Facebook"

    click_on "Venues"

    click_on "Show"

    expect(page).to have_no_content("Associated Events")
  end
end

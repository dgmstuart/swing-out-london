require "rails_helper"

RSpec.feature "Outdated events" do
  scenario "when there are no outdated events" do
    login
    visit 'outdated'
    expect(page).to have_content "All events are in date!"
  end

  scenario 'when there are outdated and nearly outdated events' do
    outdated_event = FactoryBot.create(:event, id: 1, frequency: 4, dates: [ Date.local_today - 4.weeks ])
    nearly_outdated_event = FactoryBot.create(:event, id: 2, frequency: 4, dates: [ Date.local_today + 1.week ])

    login
    visit 'outdated'

    expect(page).to have_content("1 event out of date, 1 event nearly out of date")

    expect(page).to have_link "/events/#{outdated_event.to_param}/edit"
    expect(page).to have_link "/events/#{nearly_outdated_event.to_param}/edit"

    expect(page).to have_link 'link', href: outdated_event.url
    expect(page).to have_link 'link', href: nearly_outdated_event.url

    expect(page).to have_content Date.local_today.to_s(:listing_date)

    expect(page).to have_content("Out of date events")
    expect(page).to have_content("Nearly out of date events")
  end
end

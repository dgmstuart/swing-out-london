require 'rails_helper'

RSpec.feature 'Users can view a map of upcoming events' do
  scenario 'looking at a date in the past' do
    visit '/map/socials/2015-12-25'

    expect(page).to have_content('Swing Out London')
    expect(page).to have_content('Lindy Map')
    expect(page).to have_content('We can only show you events for the next 14 days')
  end

  scenario 'looking at a misspelled day' do
    visit '/map/classes/mOoonday'

    expect(page).to have_content('Swing Out London')
    expect(page).to have_content('Lindy Map')
    expect(page).to have_content('We can only show you classes for days of the week')
  end
end

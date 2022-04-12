# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can delete venues' do
  it 'when the venue has no associated events' do
    stub_login
    create(:venue, name: "Bobby McGee's")

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Venues', match: :first

    click_on 'Delete', match: :first

    expect(page).to have_content('Events')
    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content("Bobby McGee's")
  end

  it 'when the venue has associated events' do
    stub_login
    venue = create(:venue)
    create(:event, venue: venue)

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Venues', match: :first

    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content('Delete')

    click_on 'Show'

    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content('Delete')
    expect(page).to have_content("Can't be deleted: has associated events")

    click_on 'Edit'

    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content('Delete')
    expect(page).to have_content("Can't be deleted: has associated events")
  end
end

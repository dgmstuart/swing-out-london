# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can delete organisers' do
  it 'when the organiser has no associated events' do
    stub_login
    FactoryBot.create(:organiser, name: 'Herbert White')

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Organisers', match: :first

    click_on 'Delete', match: :first

    expect(page).to have_content('Events')
    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content('Herbert White')
  end

  it 'when the organiser has associated events' do
    stub_login
    organiser = FactoryBot.create(:organiser)
    FactoryBot.create(:event, social_organiser: organiser)

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Organisers', match: :first

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

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can delete venues' do
  it 'when the venue has no associated events' do
    stub_login
    FactoryBot.create(:venue, name: "Bobby McGee's")

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Venues', match: :first

    click_on 'Destroy', match: :first

    expect(page).to have_content('Events')
    expect(page).to have_no_content('Destroy')
    expect(page).to have_no_content("Bobby McGee's")
  end

  it 'when the venue has associated events' do
    stub_login
    venue = FactoryBot.create(:venue)
    FactoryBot.create(:event, venue: venue)

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Venues', match: :first

    click_on 'Edit', match: :first

    expect do
      click_on 'Delete', match: :first
    end
      .to raise_error(ActiveRecord::DeleteRestrictionError)
  end
end

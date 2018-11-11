# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can create venues' do
  it 'with valid data', :vcr do
    stub_login(id: 12345678901234567, name: 'Al Minns')

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'New Venue'

    fill_in 'Name', with: 'The 100 Club'
    fill_in 'Address', with: "100 Oxford Street\nLondon"
    fill_in 'Postcode', with: 'W1D 1LL'
    fill_in 'Area', with: 'Oxford Street'
    fill_in 'Website', with: 'https://www.the100club.co.uk/'
    VCR.use_cassette('geocode_100_club') do
      click_on 'Create'
    end

    expect(page).to have_content('Name: The 100 Club')
    expect(page).to have_content("Address: 100 Oxford Street\r London")
    expect(page).to have_content('Postcode: W1D 1LL')
    expect(page).to have_content('Area: Oxford Street')
    expect(page).to have_content('Website: https://www.the100club.co.uk/')
    expect(page).to have_content('Coordinates: [ 51.5161046, -0.1353113 ]')

    audit_record = PaperTrail::Version.last
    expect(audit_record.item.name).to eq 'The 100 Club'
  end
end

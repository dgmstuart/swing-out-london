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
    Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
      VCR.use_cassette('geocode_100_club') do
        click_on 'Create'
      end
    end

    expect(page).to have_content('Name: The 100 Club')
    expect(page).to have_content("Address: 100 Oxford Street\r London")
    expect(page).to have_content('Postcode: W1D 1LL')
    expect(page).to have_content('Area: Oxford Street')
    expect(page).to have_content('Website: https://www.the100club.co.uk/')
    expect(page.find('a', text: 'https://www.the100club.co.uk/')['href']).to eq('https://www.the100club.co.uk/')
    expect(page).to have_content('Coordinates: [ 51.5161046, -0.1353113 ]')
    expect(page.find('a', text: '[ 51.5161046, -0.1353113 ]')['href'])
      .to eq('https://www.google.co.uk/maps/place/51.5161046,-0.1353113/@51.5161046,-0.1353113,15z')

    expect(page).to have_content('Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16')
  end
end

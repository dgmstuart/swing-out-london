# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users can see adverts' do
  it 'when no advert is enabled' do
    ClimateControl.modify(
      ADVERT_ENABLED: 'false'
    ) do
      visit '/'
    end

    expect(page).to have_link(
      'Advertise here',
      href: 'mailto:swingoutlondon@gmail.com'
    )
  end

  it 'when an advert is enabled' do
    ClimateControl.modify(
      ADVERT_ENABLED: 'true',
      ADVERT_URL: 'https://myevent.co.uk',
      ADVERT_IMAGE_URL: 'https://myevent.co.uk/banner',
      ADVERT_TITLE: 'My Event',
      ADVERT_GOOGLE_ID: 'me-1'
    ) do
      visit '/'
    end

    expect(page).to have_link(
      nil,
      href: 'https://myevent.co.uk',
      title: 'My Event',
      id: 'me-1'
    )
    expect(page).to have_xpath("//img[@src = 'https://myevent.co.uk/banner' and @alt = 'Advertisment: My Event']")
  end
end

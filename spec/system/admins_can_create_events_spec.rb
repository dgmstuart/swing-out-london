# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can create events' do
  it 'with valid data' do
    stub_login(id: 12345678901234567, name: 'Al Minns')
    FactoryBot.create(:venue, name: 'The 100 Club')
    FactoryBot.create(:organiser, name: 'The London Swing Dance Society')

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'New event', match: :first

    fill_in 'Title', with: 'Stompin\''
    fill_in 'Shortname', with: ''
    select 'The 100 Club', from: 'Venue'
    select 'The London Swing Dance Society', from: 'Social organiser'
    select 'The London Swing Dance Society', from: 'Class organiser'
    select 'school', from: 'Event type'
    check 'Has a taster?'
    check 'Has social?'
    fill_in 'Class style', with: ''
    fill_in 'Course length', with: ''
    select 'Wednesday', from: 'Day'
    fill_in 'event_frequency', with: '0'
    fill_in 'Dates', with: '12/12/2012, 19/12/2012'
    # TODO: Make this work:
    # fill_in 'Cancelled dates', with: '12/12/2012'
    fill_in 'First date', with: ''
    fill_in 'Url', with: 'http://www.lsds.co.uk/stompin'

    Timecop.freeze(Time.zone.local(2000, 1, 2, 23, 17, 16)) do
      click_on 'Update'
    end

    expect(page).to have_content('Title: Stompin\'')
      .and have_content('Shortname: ')
      .and have_content('Venue: The 100 Club')
      .and have_content('Social Organiser: The London Swing Dance Society')
      .and have_content('Class Organiser: The London Swing Dance Society')
      .and have_content('has taster: true')
      .and have_content('has class: false')
      .and have_content('has social: true')
      .and have_content('Class style:')
      .and have_content('Day: Wednesday')
      .and have_content('Frequency: One-off or intermittent')
      .and have_content('Dates: 12/12/2012,19/12/2012')
      .and have_content('Cancelled: Unknown')
      .and have_content('First date:')
      .and have_content('Url: http://www.lsds.co.uk/stompin')

    expect(page).to have_content('Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16')
  end
end

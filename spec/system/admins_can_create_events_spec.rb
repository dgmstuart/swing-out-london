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
    select 'The 100 Club', from: 'Venue'
    select 'The London Swing Dance Society', from: 'Social organiser'
    select 'The London Swing Dance Society', from: 'Class organiser'
    select 'School', from: 'Event type'
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
      click_on 'Create'
    end

    expect(page).to have_content('Title: Stompin\'')
      .and have_content('Venue: The 100 Club')
      .and have_content('Social Organiser: The London Swing Dance Society')
      .and have_content('Class Organiser: The London Swing Dance Society')
      .and have_content('School, with social and taster')
      .and have_content('Class style:')
      .and have_content('Day: Wednesday')
      .and have_content('Frequency: One-off or intermittent')
      .and have_content('Dates: 12/12/2012, 19/12/2012')
      .and have_content('Cancelled: None')
      .and have_content('First date:')
      .and have_content('Url: http://www.lsds.co.uk/stompin')

    expect(page).to have_content('Last updated by Al Minns (12345678901234567) on Sunday 2nd January 2000 at 23:17:16')
  end

  it 'with missing data' do
    stub_login(id: 12345678901234567, name: 'Al Minns')
    FactoryBot.create(:venue, name: 'The 100 Club')

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'New event', match: :first

    click_on 'Create'

    expect(page).to have_content('6 errors prohibited this record from being saved')
      .and have_content('Venue must exist')
      .and have_content('Url is invalid')
      .and have_content("Url can't be blank")
      .and have_content("Event type can't be blank")
      .and have_content("Frequency can't be blank")
      .and have_content('Events must have either a Social or a Class')

    select 'The 100 Club', from: 'Venue'
    select 'school', from: 'Event type'
    check 'Has social?'
    fill_in 'event_frequency', with: '1'
    fill_in 'Url', with: 'http://www.lsds.co.uk/stompin'

    click_on 'Create'

    expect(page).to have_content('Venue: The 100 Club')
      .and have_content('School, with social')
      .and have_content('Frequency: Weekly')
      .and have_content('Url: http://www.lsds.co.uk/stompin')
  end
end

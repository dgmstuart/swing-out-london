# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organisers can edit events' do
  context 'when an organiser token exists' do
    it 'allows an organiser to edit an occasional event' do
      create(
        :social,
        organiser_token: 'abc123',
        title: 'Midtown stomp',
        url: 'https://www.swingland.com/midtown',
        frequency: 0,
        first_date: Date.new(2001, 2, 3)
      )
      create(:venue, name: 'The 100 Club', area: 'central')

      visit('/external_events/abc123/edit')

      expect(page).to have_content('Midtown stomp')
        .and have_link('https://www.swingland.com/midtown', href: 'https://www.swingland.com/midtown')
        .and have_content("Frequency\nOccasional")

      select 'The 100 Club', from: 'Venue'
      fill_in 'Upcoming dates', with: '12/12/2012, 12/01/2013'
      fill_in 'Cancelled dates', with: '12/12/2012'
      fill_in 'Last date', with: '12/01/2013'
      click_on 'Update'

      aggregate_failures do
        expect(page).to have_select('Venue', selected: 'The 100 Club - central')
        expect(page).to have_field('Upcoming dates', with: '12/12/2012,12/01/2013')
        expect(page).to have_field('Cancelled dates', with: '12/12/2012')
        expect(page).to have_field('Last date', with: '12/01/2013')
        expect(page).to have_content('Event was successfully updated')
      end

      expect(Audit.last.username).to eq('name' => 'Organiser (abc123)', 'auth_id' => 'abc123')
    end

    it 'allows an organiser to edit a weekly event' do
      create(
        :social,
        organiser_token: 'abc123',
        title: 'Midtown stomp',
        url: 'https://www.swingland.com/midtown',
        day: 'Wednesday',
        frequency: 1,
        first_date: Date.new(2001, 2, 3)
      )
      create(:venue, name: 'The 100 Club', area: 'central')

      visit('/external_events/abc123/edit')

      expect(page).to have_content('Midtown stomp')
        .and have_link('https://www.swingland.com/midtown', href: 'https://www.swingland.com/midtown')
        .and have_content("Frequency\nEvery Wednesday")
      expect(page).not_to have_content('Upcoming dates')

      select 'The 100 Club', from: 'Venue'
      fill_in 'Cancelled dates', with: '12/12/2012'
      fill_in 'Last date', with: '12/01/2013'
      click_on 'Update'

      aggregate_failures do
        expect(page).to have_select('Venue', selected: 'The 100 Club - central')
        expect(page).not_to have_content('Upcoming dates')
        expect(page).to have_field('Cancelled dates', with: '12/12/2012')
        expect(page).to have_field('Last date', with: '12/01/2013')
        expect(page).to have_content('Event was successfully updated')
      end

      expect(Audit.last.username).to eq('name' => 'Organiser (abc123)', 'auth_id' => 'abc123')
    end

    it 'shows a sensible title for classes' do
      organiser = create(:organiser, name: 'Herbert White')
      create(:class, organiser_token: 'abc123', class_organiser: organiser)

      visit('/external_events/abc123/edit')

      expect(page).to have_content('Dance class by Herbert White')
    end

    it 'does not allow organisers to access other pages' do
      event = create(:social, organiser_token: 'abc123', title: 'Midtown stomp')

      visit('/external_events/abc123/edit')

      expect(page).to have_content('Midtown stomp')

      visit("/events/#{event.id}/edit")

      expect(page).to have_content('Log in with Facebook')
    end
  end

  context 'when the changes are invalid' do
    it 'shows validation errors' do
      create(:social, organiser_token: 'abc123')

      visit('/external_events/abc123/edit')

      select '', from: 'Venue'
      click_on 'Update'

      expect(page).to have_content('1 error prohibited this record from being saved:')
        .and have_content('Venue must exist')
    end
  end

  context 'when the organiser token is incorrect' do
    it 'redirects to the homepage' do
      visit('/external_events/abc123/edit')

      expect(page).to have_content('Listings')
    end
  end
end

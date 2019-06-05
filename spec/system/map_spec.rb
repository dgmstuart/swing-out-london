# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users can view a map of upcoming events' do
  describe 'socials page' do
    it 'viewing the page' do
      Timecop.freeze(Time.utc(2019, 6, 4, 12)) do
        visit '/map/socials'
      end

      expect(page).to have_content('Tuesday 4th June')
        .and have_content('Wednesday 5th June')
        .and have_content('Thursday 6th June')
        .and have_content('Friday 7th June')
        .and have_content('Saturday 8th June')
        .and have_content('Sunday 9th June')
        .and have_content('Monday 10th June')
        .and have_content('Tuesday 11th June')
        .and have_content('Wednesday 12th June')
        .and have_content('Thursday 13th June')
        .and have_content('Friday 14th June')
        .and have_content('Saturday 15th June')
        .and have_content('Sunday 16th June')
        .and have_content('Monday 17th June')
    end

    it 'looking at a date in the past' do
      visit '/map/socials/2015-12-25'

      expect(page).to have_content('Swing Out London')
      expect(page).to have_content('Lindy Map')
      expect(page).to have_content('We can only show you events for the next 14 days')
    end
  end

  describe 'classes page' do
    it 'viewing the page' do
      visit '/map/classes'

      expect(page).to have_content('Monday')
        .and have_content('Tuesday')
        .and have_content('Wednesday')
        .and have_content('Thursday')
        .and have_content('Friday')
        .and have_content('Saturday')
        .and have_content('Sunday')
    end

    it 'looking at a misspelled day' do
      visit '/map/classes/mOoonday'

      expect(page).to have_content('Swing Out London')
      expect(page).to have_content('Lindy Map')
      expect(page).to have_content('We can only show you classes for days of the week')
    end
  end
end

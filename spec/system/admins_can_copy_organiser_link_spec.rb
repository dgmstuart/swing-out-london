# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can copy an organiser link' do
  context 'when an organiser token exists' do
    it 'shows a url which will allow an organiser to edit an event' do
      stub_login(id: 12345678901234567, name: 'Al Minns')
      create(:event, organiser_token: 'abc123')

      visit '/login'
      click_on 'Log in with Facebook'

      click_on 'Edit', match: :first

      expect(page).to have_content('http://www.example.com/external_events/abc123/edit')
    end
  end

  context 'when an organiser token does not exist', :js do
    it 'allows one to be generated' do
      stub_login(id: 12345678901234567, name: 'Al Minns')
      create(:event, organiser_token: nil)
      allow(SecureRandom).to receive(:hex).and_return('abc123'.dup)

      visit '/login'
      click_on 'Log in with Facebook'

      click_on 'Edit', match: :first

      expect(page).to have_content('No organiser edit link exists for this event')

      click_on 'New link'

      expect(page).to have_content('/external_events/abc123/edit')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can navigate' do
  it 'from a show page to an edit page' do
    stub_login
    create(:event, url: 'https://navigating.se')

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Show', match: :first

    click_on 'Edit'

    expect(page).to have_content('Editing event')
  end
end

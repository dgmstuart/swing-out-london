# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Login' do
  it 'admins can log out' do
    visit '/events'

    click_on 'Log in with Facebook'

    click_on 'Account'

    click_on 'Log out'
    expect(page).to have_content('Log in with Facebook')

    visit '/events'
    expect(page).to have_content('Log in with Facebook')
  end
end

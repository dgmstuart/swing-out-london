# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Login' do
  it 'admins can login and access admin pages' do
    visit '/events'

    expect(page).not_to have_header('Events')

    click_on 'Log in with Facebook'

    expect(page).to have_header('Events')
    expect(page).to have_content('Archived')
  end
end

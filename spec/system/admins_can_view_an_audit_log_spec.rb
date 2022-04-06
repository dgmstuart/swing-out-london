# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can view an audit log' do
  it 'showing a list of audited events' do
    stub_login

    visit '/login'
    click_on 'Log in with Facebook'

    FactoryBot.create(:event)
    FactoryBot.create(:venue)
    FactoryBot.create(:organiser)

    ClimateControl.modify(AUDIT_LOG_USER: 'user', AUDIT_LOG_PASSWORD: 'pass') do
      page.driver.browser.authorize('user', 'pass')
      visit '/audit_log'
    end

    expect(page).to have_content('Audit Log')
  end
end

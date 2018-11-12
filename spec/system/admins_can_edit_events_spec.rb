# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins can edit events' do
  it 'adding dates' do
    stub_login(id: 12345678901234567, name: 'Al Minns')
    FactoryBot.create(:event, dates: ['12/12/2012', '13/12/2012'])

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Edit', match: :first

    fill_in 'Title', with: 'FOO'

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_on 'Update'
    end

    click_on 'Edit', match: :first

    fill_in 'Dates', with: '12/12/2012, 12/01/2013'

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_on 'Update'
    end

    expect(page).to have_content('Dates: 12/12/2012,12/01/2013')

    expect(page).to have_content('Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16')
  end

  it 'adding cancellations' do
    stub_login(id: 12345678901234567, name: 'Al Minns')
    FactoryBot.create(:event, dates: ['12/12/2012'])
    PaperTrail::Version.delete_all # So that we can be sure that the audit was for the edit

    visit '/login'
    click_on 'Log in with Facebook'

    click_on 'Edit', match: :first

    fill_in 'Cancelled dates', with: '12/12/2012'

    Timecop.freeze(Time.zone.local(2015, 1, 2, 23, 17, 16)) do
      click_on 'Update'
    end

    expect(page).to have_content('Cancelled: 12/12/2012')

    expect(page).to have_content('Last updated by Al Minns (12345678901234567) on Friday 2nd January 2015 at 23:17:16')
  end
end

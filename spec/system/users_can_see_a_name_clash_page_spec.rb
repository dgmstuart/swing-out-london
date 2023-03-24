# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users can see a name clash page' do
  it 'displays a list of social names' do
    given_a_social
    when_i_visit_the_name_clash_page
    then_i_see_the_name_of_that_social
  end

  def given_a_social
    create(:social, title: 'my awesome spectacular')
  end

  def when_i_visit_the_name_clash_page
    visit '/name_clash'
  end

  def then_i_see_the_name_of_that_social
    expect(page).to have_text('my awesome spectacular')
  end
end

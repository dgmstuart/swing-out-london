# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Audit Log RSS feed', type: :request do
  it 'displays an RSS feed of audit events' do
    audit_user = { 'auth_id' => 'abc123', 'name' => 'Pepsi Bethel' }
    Audited.store[:current_user] = -> { audit_user }
    FactoryBot.create(:venue, name: 'The Alhambra')
    FactoryBot.create(:event, title: 'The Wednesday Stomp')

    get '/audit_log.rss'

    expect(response.content_type).to eq('application/rss+xml')
  end
end

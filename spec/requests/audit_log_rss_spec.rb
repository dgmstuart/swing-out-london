# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Audit Log RSS feed", type: :request do
  it "displays an RSS feed of audit events" do
    audit_user = { "auth_id" => "abc123", "name" => "Pepsi Bethel" }
    Audited.store[:current_user] = -> { audit_user }
    create(:venue, name: "The Alhambra")
    create(:event, title: "The Wednesday Stomp")

    ClimateControl.modify(AUDIT_LOG_PASSWORD: "pass") do
      get "/audit_log.atom?password=pass"
    end

    expect(response.media_type).to eq("application/atom+xml")
  end
end

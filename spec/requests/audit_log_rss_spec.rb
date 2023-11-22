# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Audit Log RSS feed" do
  it "displays an RSS feed of audit events" do # rubocop:disable RSpec/ExampleLength
    audit_user = { "auth_id" => "abc123", "name" => "Pepsi Bethel" }
    Audited.store[:current_user] = -> { audit_user }

    venue = create(:venue, name: "The Alhambra")
    venue.update!(name: "La Mesquita")
    venue.destroy!

    event = create(:event, title: "The Wednesday Stomp")
    event.update!(title: "The Tuesday Stamp")
    event.destroy!

    create(:class)

    organiser = create(:organiser, name: "Johnny Waters")
    organiser.update!(name: "Jimmy Fire")
    organiser.destroy!

    ClimateControl.modify(AUDIT_LOG_PASSWORD: "pass") do
      get "/audit_log.atom?password=pass"
    end

    expect(response.media_type).to eq("application/atom+xml")
  end
end

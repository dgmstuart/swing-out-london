# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Audit Log RSS feed" do
  around do |example|
    ClimateControl.modify(CANONICAL_HOST: "www.swingoutlondon.co.uk") { example.run }
  end

  it "displays an RSS feed of audit events" do # rubocop:disable RSpec/ExampleLength
    audit_user = { "auth_id" => "abc123", "name" => "Pepsi Bethel" }
    Audited.store[:current_user] = -> { audit_user }

    venue = create(:venue, name: "The Alhambra")
    venue.update!(name: "La Mesquita")
    venue.destroy!

    social_dance = create(:social, title: "The Wednesday Stomp", url: "https://stomp.uk")
    social_dance.update!(title: "The Tuesday Stamp")
    social_dance.destroy!

    class_organiser = create(:organiser, name: "Maggie McMillan")
    dance_class = create(:class, url: "https://weds", class_organiser:)

    organiser = create(:organiser, name: "Johnny Waters")
    organiser.update!(name: "Jimmy Fire")
    organiser.destroy!

    ClimateControl.modify(AUDIT_LOG_PASSWORD: "pass") do
      get "/audit_log.atom?password=pass"
    end

    # rubocop:disable Layout/MultilineMethodCallIndentation
    aggregate_failures do
      expect(response.media_type).to eq("application/atom+xml")
      expected_xml = File.read(fixture_file("audit_log.xml"))
        .gsub("{{venue_id}}", venue.id.to_s)
        .gsub("{{social_dance_id}}", social_dance.id.to_s)
        .gsub("{{social_dance_venue_id}}", social_dance.venue.id.to_s)
        .gsub("{{dance_class_id}}", dance_class.id.to_s)
        .gsub("{{dance_class_organiser_id}}", class_organiser.id.to_s)
        .gsub("{{dance_class_venue_id}}", dance_class.venue.id.to_s)
        .gsub("{{organiser_id}}", organiser.id.to_s)
        .chomp # chomp to remove trailing newline

      normalised_body = response.body
        .gsub(%r{<updated>.+</updated>}, "<updated>{{updated_timestamp}}</updated>")
        .gsub(%r{<dc:date>.+</dc:date>}, "<dc:date>{{updated_timestamp}}</dc:date>")
        .gsub(/updated_at=\d+/, "updated_at={{updated_seconds}}")
        .gsub(/created_at&quot;: &quot;.*&quot;/, "created_at&quot;: &quot;{{updated_timestamp}}&quot;")
        .gsub(/day&quot;: &quot;.*&quot;/, "day&quot;: &quot;{{dance_class_day}}&quot;")
      expect(normalised_body).to eq(expected_xml)
    end
    # rubocop:enable Layout/MultilineMethodCallIndentation
  end

  private

  def fixture_file(filename)
    Rails.root.join("spec", "fixtures", filename)
  end
end

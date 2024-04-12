# frozen_string_literal: true

require "rails_helper"

RSpec.describe MapListingsHelper do
  include ActiveSupport::Testing::TimeHelpers

  describe "#mapinfo_swingclass_link" do
    context "with all the possible parts" do
      it "generates a link with information about the class" do
        travel_to "2024-04-08"
        organiser = instance_double(
          "Organiser",
          shortname: nil,
          name: "Sharon Davis"
        )
        event = instance_double(
          "Event",
          url: "https://www.facebook.com/thejazzbourne/events",
          title: "The Wednesday Club",
          has_social?: true,
          new?: true,
          started?: false,
          first_date: Date.tomorrow,
          class_style: "Solo Jazz",
          course_length: 6,
          class_organiser: organiser
        )

        result =
          '<a href="https://www.facebook.com/thejazzbourne/events">' \
          "Class (from 9th Apr) (Solo Jazz) - 6 week courses" \
          '<span class="info"> at The Wednesday Club with Sharon Davis</span> ' \
          '<strong class="new-label">New!</strong>' \
          "</a>"
        expect(helper.mapinfo_swingclass_link(event)).to eq(result)
      end
    end
  end
end

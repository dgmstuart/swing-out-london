# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/string/inflections"
require "app/services/event_summarizer"

RSpec.describe EventSummarizer do
  describe "to_s" do
    context "when the event is a social" do
      it "returns the title" do
        event = instance_double("Event",
                                has_social?: true,
                                title: "Jitterbugs")
        summary = described_class.new.summarize(event)

        expect(summary).to eq "Social: Jitterbugs"
      end
    end

    context "when the event is a class" do
      it "returns the organiser and day" do
        organiser = instance_double("Organiser", name: "Sing Lim")
        event = instance_double("Event",
                                has_social?: false,
                                day: "Thursday",
                                class_organiser: organiser)

        summary = described_class.new.summarize(event)

        expect(summary).to eq "Class with Sing Lim on Thursdays"
      end
    end
  end
end

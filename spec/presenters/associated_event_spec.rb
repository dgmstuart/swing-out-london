# frozen_string_literal: true

require "spec_helper"
require "app/presenters/associated_event"

RSpec.describe AssociatedEvent do
  describe "#summary" do
    it "builds a summary from the event" do
      event = instance_double("Event")
      summarizer = instance_double("EventSummarizer", summarize: "A summary of the event")

      associated_event = described_class.new(event, summarizer:, url_helpers: double)

      expect(associated_event.summary).to eq "A summary of the event"
    end
  end

  describe "#link" do
    it "links to the event" do
      event = instance_double("Event")
      url_helpers = double("Rails.application.routes.url_helpers") # rubocop:disable RSpec/VerifiedDoubles
      allow(url_helpers).to receive(:event_path).with(event).and_return("/path/to/event")

      associated_event = described_class.new(event, summarizer: double, url_helpers:)

      expect(associated_event.link).to eq "/path/to/event"
    end
  end
end

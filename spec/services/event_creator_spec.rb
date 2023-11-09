# frozen_string_literal: true

require "spec_helper"
require "app/services/event_creator"

RSpec.describe EventCreator do
  describe "#create!" do
    it "builds an event with the passed in params" do
      repository = class_double("Event", create!: double)
      params = double

      described_class.new(repository).create!(params)

      expect(repository).to have_received(:create!).with(params)
    end

    it "returns the created event" do
      created_event = instance_double("Event")
      repository = class_double("Event", create!: created_event)

      result = described_class.new(repository).create!(double)

      expect(result).to eq created_event
    end

    context "when there are dates" do
      it "creates SwingDate records from the dates" do
        repository = class_double("Event", create!: double)
        params = double

        described_class.new(repository).create!(params)

        expect(repository).to have_received(:create!).with(params)
      end
    end
  end
end

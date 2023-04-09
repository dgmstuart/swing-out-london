# frozen_string_literal: true

require "form_spec_helper"
require "app/forms/organiser_edit_event_form"

RSpec.describe OrganiserEditEventForm do
  describe "(validations)" do
    subject { described_class.new }

    before { stub_model_name("Event") }

    it { is_expected.to validate_presence_of(:venue_id) }
  end

  describe ".persisted?" do
    it "is always true" do
      expect(described_class.new.persisted?).to be true
    end
  end
end

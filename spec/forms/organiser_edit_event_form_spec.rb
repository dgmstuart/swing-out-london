# frozen_string_literal: true

require "form_spec_helper"
require "app/validators/dates_string_validator"
require "app/forms/organiser_edit_event_form"
require "spec/support/shared_examples/events/validates_date_string"

RSpec.describe OrganiserEditEventForm do
  describe "(validations)" do
    subject { described_class.new }

    before { stub_model_name("Event") }

    it { is_expected.to validate_presence_of(:venue_id) }

    it_behaves_like "validates date string", :dates, :organiser_edit_event_form, { allow_past: true }
    it_behaves_like "validates date string", :cancellations, :organiser_edit_event_form, { allow_past: true }
  end

  describe ".persisted?" do
    it "is always true" do
      expect(described_class.new.persisted?).to be true
    end
  end
end

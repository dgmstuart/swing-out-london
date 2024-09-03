# frozen_string_literal: true

require "form_spec_helper"
require "app/validators/form/valid_event_with_last_date"
require "spec/support/shared_examples/events/validates_dates_string"
require "spec/support/shared_examples/events/validates_cancellations_in_dates"
require "spec/support/shared_examples/events/validates_date_string"
require "spec/support/shared_examples/events/form/validates_event_with_last_date"
require "app/concerns/frequency"
require "app/forms/organiser_edit_event_form"
require "app/forms/date_form"

RSpec.describe OrganiserEditEventForm do
  describe "(validations)" do
    subject { described_class.new }

    before { stub_model_name("Event") }

    it { is_expected.to validate_presence_of(:venue_id) }

    it_behaves_like "validates dates string", :dates, :organiser_edit_event_form, { allow_past: true }
    it_behaves_like "validates dates string", :cancellations, :organiser_edit_event_form, { allow_past: true }
    it_behaves_like "validates dates in cancellations", :organiser_edit_event_form
    it_behaves_like "validates date string", :last_date, :organiser_edit_event_form
    it_behaves_like "validates event with last date (form)", :organiser_edit_event_form
  end

  describe ".persisted?" do
    it "is always true" do
      expect(described_class.new.persisted?).to be true
    end
  end

  describe "#to_h" do
    it "returns the attributes as a symbol hash" do
      form = described_class.new(
        venue_id: 1,
        dates: "10/12/2020, 12/01/2021",
        cancellations: "10/12/2020",
        last_date: "10/02/2024"
      )

      expect(form.to_h).to eq(
        venue_id: 1,
        dates: ["2020-12-10".to_date, "2021-01-12".to_date],
        cancellations: ["2020-12-10".to_date],
        last_date: "10/02/2024"
      )
    end
  end
end

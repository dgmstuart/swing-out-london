# frozen_string_literal: true

require "form_spec_helper"
require "config/initializers/inflections" # because of URI in URIValidator
require "app/validators/uri_validator"
require "app/validators/valid_social_or_class"
require "app/validators/valid_weekly_event"
require "app/validators/form/valid_event_with_dates"
require "spec/support/shared_examples/events/validates_date_string"
require "app/validators/dates_string_validator"
require "app/forms/edit_event_form"
require "spec/support/shared_examples/events/form/validates_class_and_social"
require "spec/support/shared_examples/events/validates_weekly"
require "spec/support/shared_examples/events/form/validates_event_with_dates"
require "spec/support/shared_examples/events/validates_course_length"
require "spec/support/shared_examples/validates_url"

RSpec.describe EditEventForm do
  describe "(validations)" do
    subject { described_class.new }

    before { stub_model_name("Event") }

    it_behaves_like "validates class and social (form)", :edit_event_form
    it_behaves_like "validates weekly", :edit_event_form
    it_behaves_like "validates event with dates (form)", :edit_event_form
    it_behaves_like "validates course length", :edit_event_form
    it_behaves_like "validates date string", :dates, :edit_event_form, { allow_past: true }
    it_behaves_like "validates date string", :cancellations, :edit_event_form, { allow_past: true }
    it_behaves_like "validates url", :edit_event_form

    it { is_expected.to validate_presence_of(:frequency) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:venue_id) }
  end

  describe "#action" do
    it "is 'Update'" do
      form = described_class.new

      expect(form.action).to eq "Update"
    end
  end

  describe ".persisted?" do
    it "is always true" do
      expect(described_class.new.persisted?).to be true
    end
  end
end

# frozen_string_literal: true

require "form_spec_helper"
require "config/initializers/inflections" # because of URI in URIValidator
require "app/validators/uri_validator"
require "app/validators/valid_social_or_class"
require "app/validators/valid_weekly_event"
require "app/validators/form/valid_event_with_dates"
require "app/forms/create_event_form"
require "spec/support/shared_examples/events/form/validates_class_and_social"
require "spec/support/shared_examples/events/validates_weekly"
require "spec/support/shared_examples/events/form/validates_event_with_dates"
require "spec/support/shared_examples/events/validates_course_length"
require "spec/support/shared_examples/validates_url"

RSpec.describe CreateEventForm do
  describe "(validations)" do
    subject { described_class.new }

    before { stub_model_name("Event") }

    it_behaves_like "validates class and social (form)", :create_event_form
    it_behaves_like "validates weekly", :create_event_form
    it_behaves_like "validates event with dates (form)", :create_event_form
    it_behaves_like "validates course length", :create_event_form
    it_behaves_like "validates url", :create_event_form

    it { is_expected.to validate_presence_of(:event_type) }
    it { is_expected.to validate_inclusion_of(:event_type).in_array(%w[social_dance weekly_class]) }

    it { is_expected.to validate_presence_of(:frequency) }
    it { is_expected.to validate_inclusion_of(:frequency).in_array([0, 1]) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:venue_id) }
  end

  describe "#action" do
    it "is 'Create'" do
      form = described_class.new

      expect(form.action).to eq "Create"
    end
  end

  describe "#weekly?" do
    it "is true if frequency is 1" do
      form = described_class.new(frequency: 1)

      expect(form.weekly?).to be true
    end

    it "is false if frequency is not 1" do
      form = described_class.new(frequency: 0)

      expect(form.weekly?).to be false
    end
  end

  describe "infrequent?" do
    it "is true if frequency is 0" do
      form = described_class.new(frequency: 0)

      expect(form.infrequent?).to be true
    end

    it "is true if frequency is 4" do
      form = described_class.new(frequency: 4)

      expect(form.infrequent?).to be true
    end

    it "is true if frequency is more than 4" do
      form = described_class.new(frequency: 5)

      expect(form.infrequent?).to be true
    end

    it "is false if frequency is 1" do
      form = described_class.new(frequency: 1)

      expect(form.infrequent?).to be false
    end
  end

  # Are these still a thing??
  # it "handles an event with no dates and a weekly event" do
  #   event = create(:event)
  #   event.dates = "Weekly"
  # end
  #
  # it "handles an event with no dates and adding unknown dates" do
  #   event = create(:event)
  #   event.dates = "Unknown"
  #   expect(event.swing_dates).to eq([])
  # end

  pending "multiple valid dates, one invalid date on the end"
  pending "multiple valid dates, one invalid date in the middle"
  pending "blanking out where there are existing dates"
  pending "fails to add an invalid date to an event"

  pending "save with an invalid dates array"

  pending "test with multiple dates, different orders, whitespace"

  pending "multiple valid cancellations, one invalid date on the end"
  pending "multiple valid cancellations, one invalid date in the middle"
  pending "fails to add an invalid date to an event"

  pending "save with an invalid cancellations array"

  pending "test with multiple cancellations, different orders, whitespace"
end

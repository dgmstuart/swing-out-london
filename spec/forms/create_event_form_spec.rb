# frozen_string_literal: true

require "form_spec_helper"
require "config/initializers/inflections" # because of URI in URIValidator
require "app/validators/uri_validator"
require "app/validators/valid_social_or_class"
require "app/validators/valid_weekly_event"
require "app/validators/form/valid_event_with_dates"
require "spec/support/shared_examples/events/validates_dates_string"
require "spec/support/shared_examples/events/validates_cancellations_in_dates"
require "spec/support/shared_examples/events/validates_date_string"
require "app/concerns/frequency"
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
    it_behaves_like "validates dates string", :dates, :create_event_form
    it_behaves_like "validates dates string", :cancellations, :create_event_form
    it_behaves_like "validates dates in cancellations", :create_event_form
    it_behaves_like "validates date string", :first_date, :create_event_form
    it_behaves_like "validates date string", :last_date, :create_event_form
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

    it "is false if frequency is 1" do
      form = described_class.new(frequency: 1)

      expect(form.infrequent?).to be false
    end
  end

  describe "#to_h" do
    it "returns the attributes as a symbol hash" do # rubocop:disable RSpec/ExampleLength
      form = described_class.new(
        url: "https://savoy.com",
        venue_id: 1,
        event_type: "social_dance",

        title: "Stompin",
        social_organiser_id: 2,
        social_has_class: true,

        class_style: "Savoy style",
        course_length: 3,
        class_organiser_id: 4,

        frequency: 0,
        day: nil,
        dates: "10/12/2020, 12/01/2021",
        cancellations: "10/12/2020",
        first_date: "01/02/2018",
        last_date: "10/02/2024"
      )

      expect(form.to_h).to eq(
        url: "https://savoy.com",
        venue_id: 1,

        has_social: true,
        has_class: false,
        has_taster: true,

        title: "Stompin",
        social_organiser_id: 2,

        class_style: "Savoy style",
        course_length: 3,
        class_organiser_id: 4,

        frequency: 0,
        day: nil,
        dates: ["2020-12-10".to_date, "2021-01-12".to_date],
        cancellations: ["2020-12-10".to_date],
        first_date: "01/02/2018",
        last_date: "10/02/2024"
      )
    end

    context "when the event is weekly with no course length" do
      it "returns the attributes as a symbol hash" do # rubocop:disable RSpec/ExampleLength
        form = described_class.new(
          url: "https://savoy.com",
          venue_id: 1,

          title: "",
          social_organiser_id: nil,
          social_has_class: nil,

          event_type: "weekly_class",

          class_style: "",
          course_length: "",
          class_organiser_id: 4,

          frequency: 1,
          day: "Tuesday",
          dates: "",
          cancellations: "",
          first_date: "",
          last_date: ""
        )

        expect(form.to_h).to eq(
          url: "https://savoy.com",
          venue_id: 1,

          has_social: false,
          has_class: true,
          has_taster: false,

          title: "",
          social_organiser_id: nil,

          class_style: "",
          course_length: nil,
          class_organiser_id: 4,

          frequency: 1,
          day: "Tuesday",
          dates: [],
          cancellations: [],
          first_date: "",
          last_date: ""
        )
      end
    end
  end
end

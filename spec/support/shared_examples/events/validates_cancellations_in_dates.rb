# frozen_string_literal: true

require "app/validators/valid_cancellations"
require "spec/support/time_formats_helper"
require "app/presenters/date_printer"

RSpec.shared_examples "validates dates in cancellations" do |model_name|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2010-01-01") }

  context "when the event is occasional" do
    it "is valid with cancellations which match dates" do
      form = build(model_name, :occasional, dates: "12/10/2010", cancellations: "12/10/2010")
      expect(form).to be_valid
    end

    it "is invalid with cancellations which don't match dates" do
      form = build(model_name, :occasional, dates: "12/10/2010", cancellations: "12/11/2010,15/11/2010")
      form.valid?
      expect(form.errors.messages).to eq(
        cancellations: ["contained dates which are not in the list of upcoming dates: 12/11/2010, 15/11/2010"]
      )
    end
  end

  context "when the event is weekly" do
    it "is valid with cancellations which match dates" do
      form = build(model_name, :weekly, dates: "", cancellations: "12/11/2010,15/11/2010")
      aggregate_failures do
        expect(form).to be_valid
        expect(form.errors.messages).to be_empty
      end
    end
  end
end

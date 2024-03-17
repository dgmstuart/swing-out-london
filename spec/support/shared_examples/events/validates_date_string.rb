# frozen_string_literal: true

require "app/validators/date_string_validator"

RSpec.shared_examples "validates date string" do |attribute, model_name, options = {}|
  describe attribute do
    include ActiveSupport::Testing::TimeHelpers

    before { travel_to Date.parse("2012-06-01") }

    it "is valid with a date" do
      model = build(model_name, attribute => "2012-06-30")
      model.valid?
      expect(model.errors.messages[attribute]).to be_empty
    end

    it "is invalid with a non-date" do
      model = build(model_name, attribute => "foo")
      model.valid?
      expect(model.errors.messages[attribute]).to eq(["is invalid"])
    end

    it "is invalid with a date-like string which is not a date" do
      model = build(model_name, attribute => "2012-06-31")
      model.valid?
      expect(model.errors.messages[attribute]).to eq(["is invalid"])
    end

    if options.fetch(:allow_past, true)
      it "is valid if the date is in the past" do
        model = build(model_name, attribute => "2012-03-01")
        model.valid?
        expect(model.errors.messages[attribute]).not_to include(/invalid/, /past/, /future/)
      end

      it "is invalid if dates are earlier than the start of SOLDN" do
        model = build(model_name, attribute => "2010-08-15")
        model.valid?
        expect(model.errors.messages[attribute]).to include("can't be too far in the past")
      end
    else
      it "is invalid if dates are in the past" do
        model = build(model_name, attribute => "2012-03-01")
        model.valid?
        expect(model.errors.messages[attribute]).to include("can't be in the past")
      end
    end

    it "is invalid if dates are in the distant future" do
      model = build(model_name, attribute => "2014-06-15")
      model.valid?
      expect(model.errors.messages[attribute]).to include("can't be too far in the future")
    end
  end
end

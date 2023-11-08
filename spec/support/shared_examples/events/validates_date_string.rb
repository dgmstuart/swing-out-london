# frozen_string_literal: true

require "active_support/testing/time_helpers"
require "active_support/core_ext/integer/time" # Required to call "2.years.from_now" in DatesStringValidator
require "lib/date_string_parser"

RSpec.shared_examples "validates date string" do |attribute, model_name, options = {}|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2012-06-01") }

  it "is invalid with a non-date string" do
    model = build(model_name, attribute => "foo")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo"'])
  end

  it "is valid with a date string" do
    model = build(model_name, attribute => "30/06/2012")
    expect(model).to be_valid
  end

  it "is invalid with several non-date strings" do
    model = build(model_name, attribute => "foo, 30//2012,06/30/2012")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo", "30//2012", "06/30/2012"'])
  end

  it "is invalid with a string with a mix of valid and invalid date strings" do
    model = build(model_name, attribute => "foo, 30/12/2012,06/30/2012")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo", "06/30/2012"'])
  end

  it "is valid with multiple valid dates" do
    model = build(model_name, attribute => " 30/12/2012,30/06/2012, 2/1/2013,  20/1/2013 ")
    expect(model).to be_valid
  end

  it "is invalid if it's missing commas" do
    model = build(model_name, attribute => "30/12/2012 30/06/2012, 2/1/2013")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "30/12/2012 30/06/2012"'])
  end

  it "is invalid if has extra stuff in it" do
    model = build(model_name, attribute => "30/12/2012foo")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "30/12/2012foo"'])
  end

  if options[:allow_past]
    it "is valid if dates are in the past" do
      model = build(model_name, dates: "31/05/2012")
      expect(model).to be_valid
    end
  else
    it "is invalid if dates are in the past" do
      model = build(model_name, dates: "31/05/2012")
      model.valid?
      expect(model.errors.messages).to eq(dates: ["contained some dates in the past: 31/05/2012"])
    end
  end

  it "is invalid if dates are earlier than the start of SOLDN" do
    model = build(model_name, dates: "15/08/2010")
    model.valid?
    expect(model.errors.messages).to eq(dates: ["contained some dates in the past: 15/08/2010"])
  end

  it "is invalid if dates are too far in the future" do
    model = build(model_name, dates: "02/06/2014")
    model.valid?
    expect(model.errors.messages).to eq(dates: ["contained some dates unreasonably far in the future: 02/06/2014"])
  end
end

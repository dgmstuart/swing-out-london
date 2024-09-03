# frozen_string_literal: true

RSpec.shared_examples "validates event with last date (form)" do |model_name|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2010-01-01") }

  it "is valid if it's occasional with no dates but has a last date" do
    model = build(model_name, :occasional, dates: "", last_date: "2011-11-01")
    expect(model).to be_valid
  end

  it "is valid if it's occasional and the latest date matches the last date" do
    model = build(model_name, :occasional, dates: "01/11/2011", last_date: "2011-11-01")
    expect(model).to be_valid
  end

  it "is invalid if it's occasional with a date past the last date" do
    model = build(model_name, :occasional, dates: "02/11/2011,31/10/2011", last_date: "2011-11-01")
    model.valid?
    expect(model.errors.messages).to eq(
      dates: [
        "can't include dates after the last date. " \
        "Change or remove the \"Last date\" or remove the dates which are later than this"
      ]
    )
  end
end

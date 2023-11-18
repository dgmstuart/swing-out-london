# frozen_string_literal: true

require "active_support/testing/time_helpers"

RSpec.shared_examples "validates event with dates (form)" do |model_name|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2010-01-01") }

  it "is invalid if it's weekly and has dates" do
    model = build(model_name, :weekly, dates: "12/10/2010")
    model.valid?
    expect(model.errors.messages).to eq(dates: ["must be empty for weekly events"])
  end

  it "is valid if it's occasional and has dates" do
    expect(build(model_name, :occasional, dates: "12/10/2010")).to be_valid
  end
end

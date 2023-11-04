# frozen_string_literal: true

RSpec.shared_examples "validates event with dates (form)" do |model_name|
  it "is invalid if it's weekly and has dates" do
    model = build(model_name, frequency: 1, day: 5, dates: "12/10/2010")
    model.valid?
    expect(model.errors.messages).to eq(dates: ["must be empty for weekly events"])
  end

  it "is valid if it's occasional and has dates" do
    expect(build(model_name, frequency: 0, dates: "12/10/2010")).to be_valid
  end
end

# frozen_string_literal: true

RSpec.shared_examples "validates event with dates" do |model_name|
  it "is invalid if it's weekly and has dates" do
    swing_dates = [build(:swing_date, date: "12/10/2010"), build(:swing_date, date: "12/11/2010")]
    model = build(model_name, :weekly, swing_dates:)
    model.valid?
    expect(model.errors.messages).to eq(swing_dates: ["must be empty for weekly events"])
  end

  it "is valid if it's occasional and has dates" do
    swing_dates = [build(:swing_date, date: "12/10/2010"), build(:swing_date, date: "12/11/2010")]
    expect(build(model_name, frequency: 0, swing_dates:)).to be_valid
  end
end

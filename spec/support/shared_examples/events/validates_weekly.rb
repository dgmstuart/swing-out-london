# frozen_string_literal: true

RSpec.shared_examples "validates weekly" do |model_name|
  it "is invalid if it's weekly and has no day" do
    model = build(model_name, frequency: 1, day: nil)
    model.valid?
    expect(model.errors.messages).to eq(day: ["must be present for weekly events"])
  end

  it "is valid if it's occasional and has no day" do
    expect(build(model_name, frequency: 0, day: nil)).to be_valid
  end
end

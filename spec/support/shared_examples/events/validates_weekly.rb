# frozen_string_literal: true

RSpec.shared_examples "validates weekly" do
  it "is invalid if it's weekly and has no day" do
    event = build(:event, frequency: 1, day: nil)
    event.valid?
    expect(event.errors.messages).to eq(day: ["must be present for weekly events"])
  end

  it "is valid if it's occasional and has no day" do
    expect(build(:event, frequency: 0, day: nil)).to be_valid
  end
end

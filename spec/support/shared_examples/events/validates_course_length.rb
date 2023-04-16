# frozen_string_literal: true

RSpec.shared_examples "validates course length" do
  it "is valid if blank" do
    event = build(:event, course_length: nil)

    expect(event).to be_valid
  end

  it "is valid if 1" do
    event = build(:event, course_length: nil)

    expect(event).to be_valid
  end

  it "is invalid if 0" do
    event = build(:event, course_length: 0)
    event.valid?
    expect(event.errors.messages).to eq(course_length: ["must be greater than 0"])
  end

  it "is invalid if negative" do
    event = build(:event, course_length: -1)
    event.valid?
    expect(event.errors.messages).to eq(course_length: ["must be greater than 0"])
  end

  it "is invalid if non-integer" do
    event = build(:event, course_length: 2.5)
    event.valid?
    expect(event.errors.messages).to eq(course_length: ["must be an integer"])
  end
end

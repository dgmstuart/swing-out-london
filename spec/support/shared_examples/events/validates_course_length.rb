# frozen_string_literal: true

RSpec.shared_examples "validates course length" do |model_name|
  it "is valid if blank" do
    model = build(model_name, course_length: nil)

    expect(model).to be_valid
  end

  it "is valid if 1" do
    model = build(model_name, course_length: nil)

    expect(model).to be_valid
  end

  it "is invalid if 0" do
    model = build(model_name, course_length: 0)
    model.valid?
    expect(model.errors.messages).to eq(course_length: ["must be greater than 0"])
  end

  it "is invalid if negative" do
    model = build(model_name, course_length: -1)
    model.valid?
    expect(model.errors.messages).to eq(course_length: ["must be greater than 0"])
  end

  it "is invalid if non-integer" do
    model = build(model_name, course_length: 2.5)
    model.valid?
    expect(model.errors.messages).to eq(course_length: ["must be an integer"])
  end
end

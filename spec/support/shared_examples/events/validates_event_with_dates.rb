# frozen_string_literal: true

RSpec.shared_examples "validates event with dates" do |model_name|
  it "is invalid if it's weekly and has dates" do
    event_instances = [
      build(:event_instance, date: "12/10/2010"),
      build(:event_instance, date: "12/11/2010")
    ]
    model = build(model_name, :weekly, event_instances:)
    model.valid?
    expect(model.errors.messages).to eq(event_instances: ["must all be cancelled for weekly events"])
  end

  it "is valid if it's weekly and has cancelled dates" do
    event_instances = [
      build(:event_instance, date: "12/10/2010", cancelled: true),
      build(:event_instance, date: "12/11/2010", cancelled: true)
    ]
    model = build(model_name, :weekly, event_instances:)
    model.valid?
    expect(model.errors.messages).to be_empty
  end

  it "is valid if it's occasional and has dates" do
    event_instances = [
      build(:event_instance, date: "12/10/2010"),
      build(:event_instance, date: "12/11/2010")
    ]
    expect(build(model_name, :occasional, event_instances:)).to be_valid
  end
end

# frozen_string_literal: true

RSpec.shared_examples "validates event with last date" do |model_name|
  it "is valid if it's occasional with no dates but has a last date" do
    model = build(model_name, :occasional, last_date: "2011-11-01")
    expect(model).to be_valid
  end

  it "is valid if it's occasional and the latest date matches the last date" do
    event_instances = [
      build(:event_instance, date: "01/11/2011")
    ]
    model = build(model_name, :occasional, event_instances:, last_date: "2011-11-01")
    expect(model).to be_valid
  end

  it "is invalid if it's occasional with a date past the last date" do
    event_instances = [
      build(:event_instance, date: "02/11/2011"),
      build(:event_instance, date: "31/10/2011")
    ]
    model = create(model_name, :occasional, event_instances:, last_date: "2011-11-01")
    model.valid?
    expect(model.errors.messages).to eq(dates: ["can't include dates after the last date"])
  end
end

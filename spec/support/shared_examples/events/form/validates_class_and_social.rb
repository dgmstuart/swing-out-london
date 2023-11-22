# frozen_string_literal: true

RSpec.shared_examples "validates class and social (form)" do |model_name|
  it "is valid if it's a class without a title" do
    expect(build(model_name, event_type: "weekly_class", title: nil, class_organiser_id: 7)).to be_valid
  end

  it "is invalid if it's a social without a title" do
    model = build(model_name, event_type: "social_dance", title: nil)
    model.valid?
    expect(model.errors.messages).to eq(title: ["must be present for social dances"])
  end

  it "is invalid if it has a class and doesn't have a class organiser" do
    model = build(model_name, event_type: "weekly_class", class_organiser_id: nil)
    model.valid?
    expect(model.errors.messages).to eq(class_organiser_id: ["must be present for classes"])
  end

  it "is invalid if it is a social dance with a class and doesn't have a class organiser" do
    model = build(model_name, event_type: "social_dance", social_has_class: true, class_organiser_id: nil)
    model.valid?
    expect(model.errors.messages).to eq(class_organiser_id: ["must be present for classes"])
  end
end

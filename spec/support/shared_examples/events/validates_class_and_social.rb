# frozen_string_literal: true

RSpec.shared_examples "validates class and social" do |model_name|
  it "is invalid if it has neither a class nor a social nor a taster" do
    expect(build(model_name, has_taster: false, has_social: false, has_class: false)).not_to be_valid
  end

  it "is invalid if it has a taster but no class or social" do
    expect(build(model_name, has_taster: true, has_social: false, has_class: false)).not_to be_valid
  end

  it "is valid if it has a class but no taster or social (and everything else is OK)" do
    model = build(model_name, :weekly, has_taster: false, has_social: false, has_class: true, class_organiser_id: 7)
    expect(model).to be_valid
  end

  it "is valid if it has a social but no taster or class (and everything else is OK)" do
    expect(build(model_name, has_taster: false, has_social: true, has_class: false)).to be_valid
  end

  it "is valid if it's a class without a title" do
    model =
      build(model_name, :weekly, has_taster: false, has_social: false, has_class: true, title: nil, class_organiser_id: 7)
    expect(model).to be_valid
  end

  it "is invalid if it's a social without a title" do
    model = build(model_name, has_taster: false, has_social: true, has_class: false, title: nil)
    model.valid?
    expect(model.errors.messages).to eq(title: ["must be present for social dances"])
  end

  it "is invalid if it has a class and doesn't have a class organiser" do
    model = build(model_name, :weekly, has_taster: false, has_social: false, has_class: true, class_organiser_id: nil)
    model.valid?
    expect(model.errors.messages).to eq(class_organiser_id: ["must be present for classes"])
  end

  it "is invalid if it has no social and is not weekly" do
    model = build(model_name, :occasional, has_taster: false, has_social: false, has_class: true, class_organiser_id: 7)
    model.valid?
    expect(model.errors.messages).to eq(frequency: ["must be 1 (weekly) for events without a social"])
  end

  it "is invalid (for a different reason) if it has no social and no set frequency" do
    model = build(model_name, has_taster: false, has_social: false, has_class: true, class_organiser_id: 7, frequency: nil)
    model.valid?
    expect(model.errors.messages).to eq(frequency: ["can't be blank"])
  end
end

# frozen_string_literal: true

RSpec.shared_examples "validates class and social" do
  it "is invalid if it has neither a class nor a social nor a taster" do
    expect(build(:event, has_taster: false, has_social: false, has_class: false)).not_to be_valid
  end

  it "is invalid if it has a taster but no class or social" do
    expect(build(:event, has_taster: true, has_social: false, has_class: false)).not_to be_valid
  end

  it "is valid if it has a class but no taster or social (and everything else is OK)" do
    expect(build(:event, has_taster: false, has_social: false, has_class: true, class_organiser_id: 7)).to be_valid
  end

  it "is valid if it has a social but no taster or class (and everything else is OK)" do
    expect(build(:event, has_taster: false, has_social: true, has_class: false)).to be_valid
  end

  it "is valid if it's a class without a title" do
    expect(build(:event, has_taster: false, has_social: false, has_class: true, title: nil, class_organiser_id: 7)).to be_valid
  end

  it "is invalid if it's a social without a title" do
    event = build(:event, has_taster: false, has_social: true, has_class: false, title: nil)
    event.valid?
    expect(event.errors.messages).to eq(title: ["must be present for social dances"])
  end

  it "is invalid if it has a class and doesn't have a class organiser" do
    event = build(:event, has_taster: false, has_social: false, has_class: true, class_organiser: nil)
    event.valid?
    expect(event.errors.messages).to eq(class_organiser_id: ["must be present for classes"])
  end
end

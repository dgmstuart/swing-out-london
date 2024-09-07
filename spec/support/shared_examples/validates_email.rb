# frozen_string_literal: true

RSpec.shared_examples "validates email" do |model_name, attribute|
  it "is valid with a gmail email" do
    model = build(model_name, attribute => "test@gmail.com")

    expect(model).to be_valid
  end

  it "is invalid with no @" do
    model = build(model_name, attribute => "testgmail.com")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ["doesn't look like a valid email address"])
  end

  it "is invalid with no Top Level Domain" do
    model = build(model_name, attribute => "test@gmail")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ["doesn't look like a valid email address"])
  end
end

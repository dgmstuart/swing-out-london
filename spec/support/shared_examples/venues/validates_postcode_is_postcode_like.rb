# frozen_string_literal: true

RSpec.shared_examples "validates postcode is postcode-like" do |model_name|
  it "is valid with no postcode" do
    model = build(model_name, postcode: nil)
    model.valid?
    expect(model.errors.messages[:postcode]).to be_empty
  end

  it "is valid with the longest london postcode" do
    model = build(model_name, postcode: "SW1A 1AA") # Buckingham Palace
    model.valid?
    expect(model.errors.messages[:postcode]).to be_empty
  end

  it "is valid with a short london postcode" do
    model = build(model_name, postcode: "N1 1RU") # RIP Buffalo Bar
    model.valid?
    expect(model.errors.messages[:postcode]).to be_empty
  end

  it "is invalid with something of the same length that isn't a postcode" do
    model = build(model_name, postcode: "1N UR1")
    model.valid?
    expect(model.errors.messages[:postcode]).to contain_exactly("is not a valid postcode")
  end

  it "is invalid with something which is too long" do
    model = build(model_name, postcode: "SW1AB 1AA")
    model.valid?
    expect(model.errors.messages[:postcode]).to contain_exactly("is not a valid postcode")
  end
end

# frozen_string_literal: true

RSpec.shared_examples "validates url" do |model_name|
  it { is_expected.to validate_presence_of(:url) }

  it "is valid with a valid https url" do
    model = build(model_name, url: "https://foo.com")

    expect(model).to be_valid
  end

  it "is valid with a valid http url" do
    model = build(model_name, url: "http://foo.com")

    expect(model).to be_valid
  end

  it "is invalid with url missing a scheme" do
    model = build(model_name, url: "www.foo.com")
    model.valid?
    expect(model.errors.messages).to eq(url: ["is not a valid URI"])
  end
end

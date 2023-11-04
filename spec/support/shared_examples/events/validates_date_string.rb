# frozen_string_literal: true

RSpec.shared_examples "validates date string" do |attribute, model_name|
  it "is invalid with a non-date string" do
    model = build(model_name, attribute => "foo")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo"'])
  end

  it "is valid with a date string" do
    model = build(model_name, attribute => "30/06/2012")
    expect(model).to be_valid
  end

  it "is invalid with several non-date strings" do
    model = build(model_name, attribute => "foo, 30//2012,06/30/2012")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo", "30//2012", "06/30/2012"'])
  end

  it "is invalid with a string with a mix of valid and invalid date strings" do
    model = build(model_name, attribute => "foo, 30/12/2012,06/30/2012")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "foo", "06/30/2012"'])
  end

  it "is valid with multiple valid dates" do
    model = build(model_name, attribute => " 30/12/2012,30/06/2012, 2/1/2013,  20/1/2013 ")
    expect(model).to be_valid
  end

  it "is invalid if it's missing commas" do
    model = build(model_name, attribute => "30/12/2012 30/06/2012, 2/1/2013")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "30/12/2012 30/06/2012"'])
  end

  it "is invalid if has extra stuff in it" do
    model = build(model_name, attribute => "30/12/2012foo")
    model.valid?
    expect(model.errors.messages).to eq(attribute => ['contained some invalid dates: "30/12/2012foo"'])
  end
end

# frozen_string_literal: true

require "app/validators/date_string_validator"

RSpec.shared_examples "validates date string" do |attribute, model_name|
  describe attribute do
    it "is valid with a date" do
      model = build(model_name, attribute => "2023-06-30")
      model.valid?
      expect(model.errors.messages[attribute]).to be_empty
    end

    it "is invalid with a non-date" do
      model = build(model_name, attribute => "foo")
      model.valid?
      expect(model.errors.messages[attribute]).to eq(["is invalid"])
    end

    it "is invalid with a date-like string which is not a date" do
      model = build(model_name, attribute => "2023-06-31")
      model.valid?
      expect(model.errors.messages[attribute]).to eq(["is invalid"])
    end
  end
end

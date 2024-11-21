# frozen_string_literal: true

RSpec.shared_examples "validates no one off workshops" do |model_name|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2010-01-01") }

  it "is invalid for classes happening on just one date" do
    model = build(model_name, event_type: "weekly_class", first_date: "2011-11-01", last_date: "2011-11-01")

    model.valid?
    expect(model.errors.messages).to eq(base: ["It looks like you're trying to list a one-off workshop"])
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

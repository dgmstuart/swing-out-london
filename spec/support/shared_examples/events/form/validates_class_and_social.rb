# frozen_string_literal: true

RSpec.shared_examples "validates class and social (form)" do |model_name|
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to Date.parse("2010-01-01") }

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

  it "is invalid for socials with classes which are weekly but only happening on just one date" do
    model = build(model_name, :social_dance, :with_class, :weekly, first_date: "2011-11-01", last_date: "2011-11-01")

    model.valid?
    expect(model.errors.messages)
      .to eq(frequency: ['must be "Monthly or occasionally" if a social is only happening once'])
  end

  it "is invalid for socials with no classes which are weekly but only happening on just one date" do
    model = build(model_name, :social_dance, :with_class, :weekly, first_date: "2011-11-01", last_date: "2011-11-01")

    model.valid?
    expect(model.errors.messages)
      .to eq(frequency: ['must be "Monthly or occasionally" if a social is only happening once'])
  end

  it "is invalid for classes happening on just one date" do
    model = build(model_name, :weekly_class, first_date: "2011-11-01", last_date: "2011-11-01")

    model.valid?
    message = <<~MESSAGE.chomp
      It looks like you're trying to list a one-off workshop.
      Please don't do this: we only list weekly classes on SOLDN.
    MESSAGE
    expect(model.errors.messages).to eq(base: [message])
  end

  it "is valid for occasional socials with classes happening on just one date" do
    model = build(model_name, :social_dance, :with_class, :occasional, first_date: "2011-11-01", last_date: "2011-11-01")

    expect(model).to be_valid
  end
end

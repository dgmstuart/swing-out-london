# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :event, aliases: %i[social intermittent_social] do
    title { Faker::Company.social_dance }
    has_taster { false }
    has_class { false }
    has_social { true }
    frequency { 0 }
    url { Faker::Internet.url }

    venue

    factory :class, class: "Event" do
      title { "" }
      has_class { true }
      has_social { false }
      weekly
      class_organiser factory: :organiser
    end

    factory :weekly_social do
      weekly

      trait :with_class do
        has_class { true }
        class_organiser factory: :organiser
      end
    end
  end

  trait :weekly do
    frequency { 1 }
    sequence(:day) { |wd| Date::DAYNAMES[wd % 7] }
  end

  factory :venue do
    name { "test_venue" }
    area { "test_area" }
    address { "London" }
    lat { 0.0 }
    lng { 0.0 }
    website { "http://www.example.com" }
  end

  factory :organiser do
    name { Faker::Name.lindy_hop_name }
  end

  factory :swing_date do
    date { Date.new }
  end
end

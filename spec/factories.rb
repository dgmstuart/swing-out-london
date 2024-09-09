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

    transient do
      dates { [] }
      cancellations { [] }
    end

    after(:create) do |event, evaluator|
      evaluator.dates.each do |date|
        create(:event_instance, event:, date:)
      end
      evaluator.cancellations.each do |date|
        create(:event_instance, event:, date:, cancelled: true)
      end
    end

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

    trait :with_organiser_token do
      organiser_token { SecureRandom.hex }
    end

    factory :event_with_organiser_token do
      with_organiser_token
    end
  end

  trait :weekly do
    frequency { 1 }
    sequence(:day) { |wd| Date::DAYNAMES[wd % 7] }
  end

  trait :occasional do
    frequency { 0 }
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

  factory :event_instance do
    event
    date { rand(365).days.from_now }
  end

  trait :event_form do
    title { Faker::Company.social_dance }
    event_type { "social_dance" }
    frequency { 0 }
    url { Faker::Internet.url }
    venue_id { rand(999) }
  end

  factory :create_event_form do
    event_form
  end

  factory :edit_event_form do
    event_form
  end

  factory :organiser_edit_event_form do
    venue_id { rand(999) }
  end

  factory :email_delivery

  factory :audit

  factory :role, aliases: %i[editor] do
    facebook_ref { Faker::Facebook.uid }

    role { "editor" }

    factory :admin do
      role { "admin" }
    end
  end
end

# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :event, aliases: %i[social intermittent_social] do
    title { Faker::Hipster.word }
    shortname { '' }
    class_style { '' }
    has_taster { false }
    has_class { false }
    has_social { true }
    event_type { 'school' }
    frequency { 0 }
    day { 'Monday' }
    url { Faker::Internet.url }

    venue

    factory :class, class: Event do
      has_class { true }
      has_social { false }
      frequency { 1 }
      # generate classes for different days of the week:
      sequence(:day) { |wd| Date::DAYNAMES[wd % 7] }
    end
  end

  factory :venue do
    name { 'test_venue' }
    area { 'test_area' }
    lat { 0.0 }
    lng { 0.0 }
    website { 'http://www.example.com' }
  end

  factory :organiser do
    name { 'test_organiser' }
  end

  factory :swing_date do
    date { Date.new }
  end
end

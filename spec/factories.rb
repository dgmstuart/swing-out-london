FactoryGirl.define do
  factory :event, :aliases => [:social, :intermittent_social] do
    event_type 'social'
    frequency 0 
    day 'monday'
    url 'http://www.example.com' 
    
    factory :class, :class => Event do
      event_type 'class'
      frequency 1
      # generate classes for different days of the week:
      sequence(:day) { |wd| Date::DAYNAMES[wd%7] }
    end
  end

  factory :venue do
    name "test_venue"
    area "test_area"
  end
  
  factory :organiser do
    name "test_organiser"
  end
  
end
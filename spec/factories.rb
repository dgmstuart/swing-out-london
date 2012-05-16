FactoryGirl.define do
  factory :event, :aliases => [:social, :intermittent_social] do
    has_taster false
    has_class false
    has_social true
    event_type 'school'
    frequency 0 
    day 'monday'
    url 'http://www.example.com' 
    
    factory :class, :class => Event do
      has_class true
      has_social false
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
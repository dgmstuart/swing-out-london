# frozen_string_literal: true

class ShowEvent
  def initialize(event)
    @event = event
  end

  def anchor
    "event_#{event.id}"
  end

  def cancellations
    return 'None' if event.cancellations.empty?

    print_dates(event.cancellations)
  end

  def dates
    if event.weekly?
      'Weekly'
    elsif event.dates.empty?
      'Unknown'
    else
      print_dates(event.dates)
    end
  end

  def first_date
    event.first_date&.to_s(:listing_date)
  end

  def last_date
    event.last_date&.to_s(:listing_date)
  end

  def expected_date
    event.expected_date&.to_s(:listing_date)
  end

  def frequency
    case event.frequency
    when 0 then 'One-off or intermittent'
    when 1 then 'Weekly'
    when 2 then 'Fortnightly'
    when 4..5 then 'Monthly'
    when 8 then 'Bi-Monthly'
    when 26 then 'Twice-yearly'
    when 52 then 'Yearly'
    when 1..100 then "Every #{event.frequency} weeks"
    else 'Unknown'
    end
  end

  def warning
    return if event.has_class? || event.has_social?

    if event.has_taster?
      'This event has a taster but no class or social, so it won\'t show up in the listings'
    else
      'This event doesn\'t have class or social, so it won\'t show up in the listings'
    end
  end

  def to_model
    event
  end

  delegate :class_organiser,
           :class_style,
           :course_length,
           :day,
           :event_type,
           :has_class?,
           :has_social?,
           :has_taster?,
           :social_organiser,
           :title,
           :url,
           :venue,
           :weekly?,
           to: :event

  private

  attr_reader :event

  def print_dates(dates)
    dates.map { |date| date.to_s(:uk_date) }.join(', ')
  end
end

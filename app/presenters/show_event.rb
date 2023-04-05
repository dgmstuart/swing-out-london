# frozen_string_literal: true

class ShowEvent
  def initialize(event)
    @event = event
    @date_printer = DatePrinter.new(separator: ", ")
  end

  def anchor
    "event_#{event.id}"
  end

  def cancellations
    return "None" if event.cancellations.empty?

    date_printer.print(event.cancellations)
  end

  def dates
    if event.weekly?
      "Weekly"
    elsif event.dates.empty?
      "Unknown"
    else
      date_printer.print(event.dates)
    end
  end

  def first_date
    event.first_date&.to_s(:listing_date)
  end

  def last_date
    event.last_date&.to_s(:listing_date)
  end

  def event_type
    activities = []
    activities << "social" if event.has_social?
    activities << "taster" if event.has_taster?
    activities << "class" if event.has_class?
    "#{event.event_type.humanize}, with #{activities.join(' and ')}"
  end

  def frequency # rubocop:disable Metrics/MethodLength
    case event.frequency
    when 0 then "Monthly or occasionally"
    when 1 then "Weekly on #{event.day.pluralize}"
    when 2 then "Fortnightly"
    when 4..5 then "Monthly"
    when 8 then "Bi-Monthly"
    when 26 then "Twice-yearly"
    when 52 then "Yearly"
    when 1..100 then "Every #{event.frequency} weeks"
    else "Unknown"
    end
  end

  def warning
    return if event.has_class? || event.has_social?

    if event.has_taster?
      "This event has a taster but no class or social, so it won't show up in the listings"
    else
      "This event doesn't have class or social, so it won't show up in the listings"
    end
  end

  def to_model
    event
  end

  delegate :class_organiser,
           :class_style,
           :course_length,
           :day,
           :social_organiser,
           :title,
           :to_param,
           :url,
           :venue,
           :weekly?,
           to: :event

  private

  attr_reader :event, :date_printer
end

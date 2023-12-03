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
    format_date(event.first_date)
  end

  def last_date
    format_date(event.last_date)
  end

  def event_type
    activities = []
    activities << "social" if event.has_social?
    activities << "taster" if event.has_taster?
    activities << "class" if event.has_class?
    activities.join(" with ").capitalize
  end

  def frequency
    {
      2 => "Fortnightly",
      4 => "Monthly",
      8 => "Bi-Monthly",
      26 => "Twice-yearly",
      52 => "Yearly"
    }.fetch(event.frequency) do |frequency|
      case frequency
      when 0 then "Monthly or occasionally"
      when 1 then "Weekly on #{event.day.pluralize}"
      else
        "Every #{frequency} weeks"
      end
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

  def format_date(date)
    return unless date

    I18n.l(date, format: :listing_date)
  end
end

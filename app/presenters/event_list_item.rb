# frozen_string_literal: true

# Presenter for displaying {Event}s to editors in a list
class EventListItem
  def initialize(event, date_printer: DatePrinter.new(separator: ", "))
    @event = event
    @date_printer = date_printer
  end

  def to_model
    event.to_model
  end

  def to_param
    event.to_param
  end

  def cache_key_with_version
    event.cache_key_with_version
  end

  def venue
    event.venue
  end

  def venue_name
    event.venue_name
  end

  def venue_area
    event.venue_area
  end

  def url
    event.url
  end

  def frequency
    event.frequency
  end

  def social_organiser
    event.social_organiser
  end

  def class_organiser
    event.class_organiser
  end

  def title
    event.title
  end

  def updated_at
    event.updated_at
  end

  def html_id
    "event_#{event.id}"
  end

  def css_class
    if ended?
      "inactive"
    elsif !future_dates?
      "no_future_dates"
    end
  end

  def print_dates_rows
    if ended?
      "Ended"
    elsif weekly?
      "Every week on #{day.pluralize}"
    elsif dates.empty?
      "(No dates)"
    else
      date_printer.print(dates.reverse)
    end
  end

  private

  attr_reader :event, :date_printer

  def ended?
    event.ended?
  end

  def weekly?
    event.weekly?
  end

  def dates
    event.dates
  end

  def day
    event.day
  end

  def future_dates?
    event.future_dates?
  end
end

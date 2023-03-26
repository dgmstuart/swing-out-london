# frozen_string_literal: true

class SocialsListings
  def initialize(
    event_finder: ->(date) { Event.socials_on_date(date) },
    cancellation_finder: ->(date) { Event.cancelled_on_date(date) }
  )
    @event_finder = event_finder
    @cancellation_finder = cancellation_finder
  end

  class << self
    def for_venue(venue)
      event_finder = ->(date) { Event.socials_on_date_for_venue(date, venue) }
      new(event_finder:)
    end
  end

  def build(dates)
    dates.each_with_object([]) do |date, listings|
      events_on_date = event_finder.call(date).sort_by(&:title)
      next if events_on_date.empty?

      ids_of_cancelled_events = cancellation_finder.call(date)

      listings << [date, events_on_date, ids_of_cancelled_events]
    end
  end

  private

  attr_reader :event_finder, :cancellation_finder
end

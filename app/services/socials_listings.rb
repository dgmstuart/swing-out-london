# frozen_string_literal: true

class SocialsListings
  def initialize(
    event_finder: ->(date) { Event.socials_on_date(date) },
    cancellation_finder: ->(date) { Event.cancelled_on_date(date) },
    presenter_class: SocialListing
  )
    @event_finder = event_finder
    @cancellation_finder = cancellation_finder
    @presenter_class = presenter_class
  end

  class << self
    def for_map(venue)
      new(
        event_finder: ->(date) { Event.socials_on_date_for_venue(date, venue) },
        presenter_class: Map::SocialListing
      )
    end
  end

  def build(dates)
    dates.each_with_object([]) do |date, listings|
      events_on_date = event_finder.call(date).sort_by(&:title)
      next if events_on_date.empty?

      ids_of_cancelled_events = cancellation_finder.call(date)

      listings << date_listing(date, events_on_date, ids_of_cancelled_events)
    end
  end

  private

  attr_reader :event_finder, :cancellation_finder, :presenter_class

  def date_listing(date, events_on_date, ids_of_cancelled_events)
    [
      date,
      events_on_date.map { |event| build_presenter(event, ids_of_cancelled_events) }
    ]
  end

  def build_presenter(event, ids_of_cancelled_events)
    cancelled = ids_of_cancelled_events.include?(event.id)
    presenter_class.new(event, cancelled:)
  end
end

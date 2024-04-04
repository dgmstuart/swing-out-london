# frozen_string_literal: true

class SocialsListings
  def initialize(
    event_finder: ->(date) { Event.socials_on_date(date) },
    presenter_class: SocialListing
  )
    @event_finder = event_finder
    @presenter_class = presenter_class
  end

  class << self
    def for_map(venue)
      new(
        event_finder: ->(date) { Event.socials_on_date_for_venue(date, venue) },
        presenter_class: Maps::SocialListing
      )
    end
  end

  def build(dates)
    dates.each_with_object([]) do |date, listings|
      events_on_date = event_finder.call(date).sort_by(&:title)
      next if events_on_date.empty?

      listings << date_listing(date, events_on_date)
    end
  end

  private

  attr_reader :event_finder, :cancellation_finder, :presenter_class

  def date_listing(date, events_on_date)
    # We can call event.cancelled because we've done a join and selected that field from the EventInstance
    [
      date,
      events_on_date.map { |event| presenter_class.new(event, cancelled: !!event.cancelled) } # rubocop:disable Style/DoubleNegation
    ]
  end
end

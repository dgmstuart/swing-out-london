# frozen_string_literal: true

module Maps
  class Markers
    attr_reader :highlighted_venue

    def initialize(
      listings_builder:,
      info_window_partial:,
      renderer:,
      venue_info_builder: Maps::Marker::Venue
    )
      @listings_builder = listings_builder
      @info_window_partial = info_window_partial
      @renderer = renderer
      @venue_info_builder = venue_info_builder
    end

    class << self
      def for_classes(selected_day:, renderer:)
        new(
          listings_builder: Maps::Marker::ListingsBuilder.for_classes(day: selected_day),
          info_window_partial: "classes_map_info",
          renderer:
        )
      end

      def for_socials(selected_date:, renderer:)
        new(
          listings_builder: Maps::Marker::ListingsBuilder.for_socials(date: selected_date),
          info_window_partial: "socials_map_info",
          renderer:
        )
      end
    end

    def for_venues(venues:, highlighted_venue_id:)
      venues.map { |venue| marker(venue:, highlighted: venue.id == highlighted_venue_id) }
    end

    private

    attr_reader :listings_builder, :info_window_partial, :renderer, :venue_info_builder

    def marker(venue:, highlighted:)
      position = { lat: venue.lat, lng: venue.lng }
      {
        id: venue.id,
        title: venue.name,
        url: venue.website,
        position:,
        highlighted:,
        infoWindowContent: info_window_content(venue)
      }
    end

    def info_window_content(venue)
      renderer.render_to_string(
        partial: info_window_partial,
        formats: [:html],
        locals: {
          venue: venue_info_builder.new(venue),
          listings: listings_builder.build(venue)
        }
      )
    end
  end
end

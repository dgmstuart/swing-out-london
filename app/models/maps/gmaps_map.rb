# frozen_string_literal: true

module Maps
  class GmapsMap
    attr_reader :highlighted_venue

    def initialize(venues:, highlighted_venue_id:, event_finder:, info_window_partial:, renderer:)
      @venues = venues
      @highlighted_venue_id = highlighted_venue_id
      @event_finder = event_finder
      @info_window_partial = info_window_partial
      @renderer = renderer
    end

    def options
      { 'zoom' => 14, 'auto_zoom' => false } if venues.count == 1
    end

    def json
      venues.to_gmaps4rails do |venue, marker|
        marker.infowindow render_info_window(venue)

        # N.B. If the given ID doesn't match any of those venues, just ignore it #TODO - should maybe be 404 instead?
        @highlighted_venue = venue if venue_is_highlighted?(venue)
        marker.json(marker_json(venue))
      end
    end

    private

    attr_reader :venues, :highlighted_venue_id, :event_finder, :info_window_partial, :renderer

    def marker_json(venue)
      { id: venue.id, title: venue.name }.tap do |json_options|
        highlighted_marker = 'https://maps.google.com/mapfiles/marker_purple.png'
        json_options[:picture] = highlighted_marker if venue_is_highlighted?(venue)
      end
    end

    def venue_is_highlighted?(venue)
      venue.id.to_s == highlighted_venue_id
    end

    def render_info_window(venue)
      renderer.render_to_string(partial: info_window_partial, locals: { venue: venue, events: event_finder.find(venue) })
    end
  end
end

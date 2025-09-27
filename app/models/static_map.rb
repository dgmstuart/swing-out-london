# frozen_string_literal: true

class StaticMap
  def initialize( # rubocop:disable Metrics/ParameterLists
    lat:,
    lng:,
    width:,
    height:,
    api_key: ENV.fetch("GOOGLE_MAPS_STATIC_API_KEY", nil),
    map_id: ENV.fetch("GOOGLE_MAPS_MAP_ID", nil)
  )
    @lat = lat
    @lng = lng
    @width = width
    @height = height
    @api_key = api_key
    @map_id = map_id
  end

  class << self
    def from_venue(
      venue:,
      width:,
      height:,
      api_key: ENV.fetch("GOOGLE_MAPS_STATIC_API_KEY", nil),
      map_id: ENV.fetch("GOOGLE_MAPS_MAP_ID", nil)
    )
      new(lat: venue.lat, lng: venue.lng, width:, height:, map_id:, api_key:)
    end
  end

  def url
    return unless api_key

    query_params = {
      center: coordinates,
      markers: coordinates,
      zoom: 17,
      size: dimensions,
      maptype: "roadmap",
      key: api_key
    }
    query_params.merge!(map_id:) if map_id

    "https://maps.googleapis.com/maps/api/staticmap?#{query_params.to_query}"
  end

  private

  attr_reader :lat, :lng, :width, :height, :api_key, :map_id

  def dimensions
    [width, height].join("x")
  end

  def coordinates
    [lat, lng].join(",")
  end
end

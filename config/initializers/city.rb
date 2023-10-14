# frozen_string_literal: true

class MapConfig
  def initialize(center:, zoom:)
    @center = center
    @zoom = zoom
  end

  def to_h
    {
      center: {
        lat: @center.lat,
        lng: @center.lng
      },
      zoom: @zoom
    }
  end
end

Coordinates = Struct.new(:lat, :lng)

City = Struct.new(:key, :map_config, :has_facebook_page?)
CITY =
  case ENV.fetch("CITY", "london")
  when "bristol"
    map_config = MapConfig.new(
      center: Coordinates.new(51.4750364, -2.5659198),
      zoom: 12
    )
    City.new(:bristol, map_config, false)
  else
    map_config = MapConfig.new(
      center: Coordinates.new(51.526532, -0.087777), # Bar Nightjar
      zoom: 11
    )
    City.new(:london, map_config, true)
  end

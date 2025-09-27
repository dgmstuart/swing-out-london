# frozen_string_literal: true

# Data object for configuring the starting location and zoom level of a map.
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

Coordinates = Data.define(:lat, :lng)

City = Data.define(:key, :map_config, :opengraph_image) do
  class << self
    def build_london
      map_config = MapConfig.new(
        center: Coordinates.new(lat: 51.526532, lng: -0.087777), # Bar Nightjar
        zoom: 11
      )
      new(key: :london, map_config:, opengraph_image: "swingoutlondon_og.png")
    end

    def build_bristol
      map_config = MapConfig.new(
        center: Coordinates.new(lat: 51.4750364, lng: -2.5659198),
        zoom: 12
      )
      new(key: :bristol, map_config:, opengraph_image: "swingoutbristol_og.png")
    end
  end

  def london?
    key == :london
  end
end

CITY =
  case ENV.fetch("CITY", "london")
  when "bristol"
    City.build_bristol
  else
    City.build_london
  end

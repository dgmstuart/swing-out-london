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

City = Struct.new(:key, :map_config, :has_facebook_page?) do
  class << self
    def build_london
      map_config = MapConfig.new(
        center: Coordinates.new(51.526532, -0.087777), # Bar Nightjar
        zoom: 11
      )
      new(:london, map_config, true)
    end

    def build_bristol
      map_config = MapConfig.new(
        center: Coordinates.new(51.4750364, -2.5659198),
        zoom: 12
      )
      new(:bristol, map_config, false)
    end
  end
end

CITY =
  case ENV.fetch("CITY", "london")
  when "bristol"
    City.build_bristol
  else
    City.build_london
  end

# frozen_string_literal: true

module Maps
  class EmptyMap
    def json
      {}
    end

    def options
      {
        center_latitude: 51.5264,
        center_longitude: -0.0878,
        zoom: 11
      }
    end

    def highlighted_venue
      nil
    end
  end
end

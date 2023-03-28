# frozen_string_literal: true

module VenuesHelper
  def venue_row_tag(venue)
    class_string = class_names(no_future_dates: venue.no_future_dates?)

    tag :tr, { class: class_string, id: "venue_#{venue.id}" }, true
  end

  def google_maps_url(lat, lng, zoom = 15)
    "https://www.google.co.uk/maps/place/#{lat},#{lng}/@#{lat},#{lng},#{zoom}z"
  end
end

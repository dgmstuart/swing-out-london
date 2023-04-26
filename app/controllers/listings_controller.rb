# frozen_string_literal: true

class ListingsController < ApplicationController
  layout "website"

  caches_action :index, cache_path: -> { Audit.last.cache_key }, layout: true, expires_in: 1.hour, race_condition_ttl: 10

  def index
    # Varnish and users browsers will cache the page for 3600 seconds = 1 hour:
    response.headers["Cache-Control"] = "public, max-age=3600"

    @today = today
    @classes = Event.listing_classes.includes(:venue, :class_organiser, :swing_cancellations)
    dates = SOLDNTime.listing_dates
    @socials_dates = SocialsListings.new.build(dates)

    @ad = Advert.current
  end
end

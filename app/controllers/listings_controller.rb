# frozen_string_literal: true

class ListingsController < ApplicationController
  layout "website"

  caches_action :index, cache_path: -> { action_cache_key }, layout: true, expires_in: 1.hour, race_condition_ttl: 10

  def index
    @today = SOLDNTime.today
    @classes = Event.listing_classes.includes(:venue, :class_organiser).map { ClassListing.new(_1) }
    dates = SOLDNTime.listing_dates
    @socials_dates = SocialsListings.new.build(dates)
  end

  def action_cache_key
    return if Audit.none?

    "listings-#{Audit.last.cache_key}"
  end
end

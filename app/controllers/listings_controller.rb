# frozen_string_literal: true

class ListingsController < ApplicationController
  layout "website"

  around_action :cache_index, only: :index

  def index
    @today = SOLDNTime.today
    @classes = Event.listing_classes.includes(:venue, :class_organiser).map { ClassListing.new(_1) }
    dates = SOLDNTime.listing_dates
    @socials_dates = SocialsListings.new.build(dates)
  end

  private

  def cache_key
    return if Audit.none?

    "listings-#{Audit.last.cache_key}"
  end

  def cache_index(&)
    cache_action(cache_key, &)
  end
end

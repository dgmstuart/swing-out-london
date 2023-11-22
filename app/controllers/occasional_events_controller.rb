# frozen_string_literal: true

class OccasionalEventsController < CmsBaseController
  layout "website"

  def index
    @today = SOLDNTime.today

    event_finder = ->(date) { Event.occasional_socials_on(date).includes(:venue) }
    dates = SOLDNTime.listing_dates(number_of_days: 6.months.in_days)
    @socials_dates = SocialsListings.new(event_finder:, presenter_class: OccasionalSocialListing).build(dates)
    @last_updated = LastUpdated.new
  end
end

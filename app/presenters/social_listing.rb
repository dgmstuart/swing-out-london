# frozen_string_literal: true

# Presenter for displaying {Event}s with social dances as listings.
class SocialListing
  def initialize(event, cancelled: false, url_helpers: Rails.application.routes.url_helpers)
    @event = event
    @cancelled = cancelled
    @url_helpers = url_helpers
  end

  delegate(
    :id,
    :title,
    :venue_postcode,
    :url,
    :new?,
    to: :event
  )

  def cancelled?
    cancelled
  end

  def highlight?
    event.infrequent?
  end

  def location
    "#{event.venue_name} in #{event.venue_area}"
  end

  def map_url(date)
    return unless show_on_map?

    url_helpers.map_socials_date_path(date: date.to_fs(:db), venue_id: event.venue_id)
  end

  private

  attr_reader :event, :cancelled, :url_helpers

  def show_on_map?
    !event.venue_coordinates.nil?
  end
end

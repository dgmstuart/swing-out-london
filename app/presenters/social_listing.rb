# frozen_string_literal: true

class SocialListing
  def initialize(event, cancelled: false)
    @event = event
    @cancelled = cancelled
  end

  delegate(
    :id,
    :title,
    :venue,
    :url,
    :new?,
    :has_class?, # only for map
    :has_taster?, # only for map
    :class_style, # only for map
    :class_organiser, # only for map
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

  private

  attr_reader :event, :cancelled
end

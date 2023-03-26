# frozen_string_literal: true

class SocialListing
  def initialize(event)
    @event = event
  end

  delegate(
    :id,
    :title,
    :venue,
    :venue_id,
    :venue_name,
    :venue_area,
    :url,
    :new?,
    :less_frequent?,
    :has_class?, # only for map
    :has_taster?, # only for map
    :class_style, # only for map
    :class_organiser, # only for map
    to: :event
  )

  private

  attr_reader :event
end

# frozen_string_literal: true

class ClassListing
  def initialize(event)
    @event = event
  end

  delegate(
    :url,
    :title,
    :day,
    :class_organiser,
    :class_style,
    :course_length,
    :new?,
    :started?,
    :has_social?,
    :first_date,
    :future_cancellations,
    :venue,
    :venue_area,
    :venue_postcode,
    to: :event
  )

  private

  attr_reader :event
end

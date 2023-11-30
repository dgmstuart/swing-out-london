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
    :new?,
    :has_social?,
    :future_cancellations,
    :venue,
    :venue_area,
    :venue_postcode,
    to: :event
  )

  def details
    details = []
    details << event.venue_area
    details << "(from #{event.first_date.to_fs(:short_date)})" unless event.started?
    details << "(#{event.class_style})" if event.class_style.present?
    details << "- #{event.course_length} week courses" if event.course_length.present?
    details.join(" ")
  end

  private

  attr_reader :event
end

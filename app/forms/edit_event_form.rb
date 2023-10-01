# frozen_string_literal: true

class EditEventForm < CreateEventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def from_event(event)
      date_printable_event = DatePrintableEvent.new(event)
      new(
        {
          title: event.title,
          url: event.url,
          venue_id: event.venue_id,

          has_social: event.has_social,
          social_organiser_id: event.social_organiser_id,

          has_class: event.has_class,
          has_taster: event.has_taster,
          class_style: event.class_style,
          course_length: event.course_length,
          class_organiser_id: event.class_organiser_id,

          frequency: event.frequency,
          day: event.day,
          dates: date_printable_event.print_dates,
          cancellations: date_printable_event.print_cancellations,
          first_date: event.first_date,
          last_date: event.last_date
        }
      )
    end
  end

  def action
    "Update"
  end

  def persisted?
    true
  end
end

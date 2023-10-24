# frozen_string_literal: true

class ValidWeeklyEvent < ActiveModel::Validator
  def validate(event)
    weekly_events_must_have_day(event)
  end

  private

  def weekly_events_must_have_day(event)
    return unless event.weekly? && event.day.blank?

    event.errors.add(:day, "must be present for weekly events")
  end
end

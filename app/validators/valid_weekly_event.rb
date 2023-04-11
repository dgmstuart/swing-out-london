# frozen_string_literal: true

class ValidWeeklyEvent < ActiveModel::Validator
  def validate(event)
    weekly_events_must_have_day(event)
    cannot_be_weekly_and_have_dates(event)
  end

  private

  def weekly_events_must_have_day(event)
    return unless event.weekly? && event.day.blank?

    event.errors.add(:day, "must be present for weekly events")
  end

  def cannot_be_weekly_and_have_dates(event)
    return unless event.weekly? && !event.dates.empty?

    event.errors.add(:date_array, "must be empty for weekly events")
  end
end

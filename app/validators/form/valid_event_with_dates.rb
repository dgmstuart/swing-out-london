# frozen_string_literal: true

module Form
  class ValidEventWithDates < ActiveModel::Validator
    def validate(event)
      cannot_be_weekly_and_have_dates(event)
    end

    private

    def cannot_be_weekly_and_have_dates(event)
      return unless event.weekly? && event.dates.present? # ANY text in the dates field is considered invalid

      event.errors.add(:dates, "must be empty for weekly events")
    end
  end
end

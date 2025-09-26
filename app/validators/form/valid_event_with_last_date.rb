# frozen_string_literal: true

module Form
  class ValidEventWithLastDate < ActiveModel::Validator
    def validate(event)
      return if event.last_date.blank?

      cannot_have_dates_after_last_date(event)
      cannot_have_cancellations_after_last_date(event)
    end

    private

    def cannot_have_dates_after_last_date(event)
      return if event.parsed_dates.empty?
      return unless event.parsed_dates.max > Date.parse(event.last_date)

      event.errors.add(
        :dates,
        "can't include dates after the last date. " \
        "Change or remove the \"Last date\" or remove the dates which are later than this"
      )
    end

    def cannot_have_cancellations_after_last_date(event)
      return if event.parsed_cancellations.empty?
      return unless event.parsed_cancellations.max > Date.parse(event.last_date)

      event.errors.add(
        :cancellations,
        "can't include dates after the last date. " \
        "Change or remove the \"Last date\" or remove the cancelled dates which are later than this"
      )
    end
  end
end

# frozen_string_literal: true

module Form
  class ValidEventWithLastDate < ActiveModel::Validator
    def validate(event)
      cannot_have_dates_after_last_date(event)
    end

    private

    def cannot_have_dates_after_last_date(event)
      return if event.last_date.blank?
      return if event.parsed_dates.empty?
      return unless event.parsed_dates.max > Date.parse(event.last_date)

      event.errors.add(
        :dates,
        "can't include dates after the last date. " \
        "Change or remove the \"Last date\" or remove the dates which are later than this"
      )
    end
  end
end

# frozen_string_literal: true

class DatesStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    invalid_dates = invalid_date_strings(value)
    return unless invalid_dates.any?

    message = "contained some invalid dates: #{invalid_dates.join(', ')}"
    record.errors.add(attribute, message)
  end

  private

  def invalid_date_strings(dates_string)
    date_strings = dates_string.split(",").map(&:strip)
    date_strings.each_with_object([]) do |date_string, array|
      date = parse_date(date_string)
      array << %("#{date_string}") unless date
    end
  end

  def parse_date(date_string, &)
    # if the string contains extra characters,
    # Date.strptime will parse the part of the string which looks like a date
    # and ignore the rest
    return unless contains_only_date_characters(date_string)

    Date.strptime(date_string, "%d/%m/%Y")
  rescue Date::Error
    false
  end

  def contains_only_date_characters(string)
    !!string.match(%r{^[0-9/]+$})
  end
end

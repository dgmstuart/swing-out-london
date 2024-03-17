# frozen_string_literal: true

require "date_string_parser"

class DateStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    date = parser.parse(value)
    if date
      validation_errors_for(date).each do |error|
        record.errors.add(attribute, error.message)
      end
    else
      record.errors.add(attribute, "is invalid")
    end
  end

  private

  def parser
    DateStringParser.for_database_format
  end

  def validation_errors_for(date)
    DateForm
      .new(date, allow_past: options.fetch(:allow_past, true))
      .tap(&:validate)
      .errors
  end
end

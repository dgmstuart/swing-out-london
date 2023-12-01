# frozen_string_literal: true

require "date_string_parser"

class DateStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if parser.parse(value)

    record.errors.add(attribute, "is invalid")
  end

  private

  def parser
    DateStringParser.new
  end
end

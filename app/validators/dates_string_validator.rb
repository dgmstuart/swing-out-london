# frozen_string_literal: true

require "dates_string_parser"

class DatesStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = parse(value)
    errors.each do |type, problem_dates|
      description = {
        invalid: "contained some invalid dates",
        past: "contained some dates in the past",
        distant_past: "contained some dates in the distant past",
        distant_future: "contained some dates unreasonably far in the future",
        duplicate: "contained some dates more than once"
      }.fetch(type)
      message = "#{description}: #{problem_dates.join(', ')}"

      record.errors.add(attribute, message)
    end
  end

  private

  def parse(dates_string)
    parser.parse(dates_string) do |date, date_string, result|
      form = DateForm.new(date, allow_past: options[:allow_past])
      if form.invalid?
        form.errors.each do |error|
          result[:errors][error.type] << date_string
        end
      end
    end
  end

  def parser
    DatesStringParser.new(formatter: ErrorsFormat.new)
  end

  class ErrorsFormat
    def transform(parse_result)
      parse_result.fetch(:errors)
    end
  end
end

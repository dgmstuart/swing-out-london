# frozen_string_literal: true

require "date_string_parser"

# Parses a comma-separated string of dates in the "dd/mm/yyyy" format and
# returns an array of Date objects.
#
# @example
#   parse("12/05/2022,23/06/2023,01/01/2024") #=> [#<Date: 2022-05-12>, #<Date: 2023-06-23>, #<Date: 2024-01-01>]
class DatesStringParser
  def initialize(date_string_parser: DateStringParser.new, formatter: DateListFormat.new)
    @date_string_parser = date_string_parser
    @formatter = formatter
  end

  # @param [String] date_string the string containing the comma-separated dates.
  # @return [Array<Date>] an array of Date objects.
  def parse(date_string, &)
    date_strings = String(date_string).split(",").map(&:strip)
    parse_result = parse_strings(date_strings, &)
    formatter.transform(parse_result)
  end

  private

  attr_reader :date_string_parser, :formatter

  def parse_strings(date_strings, &) # rubocop:disable Metrics/MethodLength
    date_strings.each_with_object(empty_result) do |date_string, result|
      date = date_string_parser.parse(date_string)

      case validate(date, result)
      in :valid
        result[:dates] << date
        yield(date, date_string, result) if block_given?
      in :duplicate
        result[:errors][:duplicate] << date_string
      in :invalid
        result[:errors][:invalid] << %("#{date_string}")
      end
    end
  end

  def validate(date, result)
    if date
      if result[:dates].include?(date)
        :duplicate
      else
        :valid
      end
    else
      :invalid
    end
  end

  def empty_result
    { dates: Set.new, errors: empty_hash_of_arrays }
  end

  def empty_hash_of_arrays
    Hash.new { |hash, key| hash[key] = [] }
  end

  # @private
  class DateListFormat
    def transform(parse_result)
      parse_result.fetch(:dates).to_a
    end
  end
end

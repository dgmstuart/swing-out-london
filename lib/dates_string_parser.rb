# frozen_string_literal: true

require "date_string_parser"

class DatesStringParser
  def initialize(date_string_parser: DateStringParser.new, formatter: DateListFormat.new)
    @date_string_parser = date_string_parser
    @formatter = formatter
  end

  def parse(date_string, &)
    date_strings = String(date_string).split(",").map(&:strip)
    parse_result = parse_strings(date_strings, &)
    formatter.transform(parse_result)
  end

  private

  attr_reader :date_string_parser, :formatter

  def parse_strings(date_strings, &)
    date_strings.each_with_object(empty_result) do |date_string, result|
      date = date_string_parser.parse(date_string)
      if date
        result[:dates] << date
        yield(date, date_string, result) if block_given?
      else
        result[:errors][:invalid] << %("#{date_string}")
      end
    end
  end

  def empty_result
    { dates: [], errors: empty_hash_of_arrays }
  end

  def empty_hash_of_arrays
    Hash.new { |hash, key| hash[key] = [] }
  end

  class DateListFormat
    def transform(parse_result)
      parse_result.fetch(:dates).uniq
    end
  end
end

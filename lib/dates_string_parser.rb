# frozen_string_literal: true

require "date_string_parser"

class DatesStringParser
  def initialize(date_string_parser: DateStringParser.new)
    @date_string_parser = date_string_parser
  end

  def parse(date_string)
    date_strings = String(date_string).split(",").map(&:strip)
    date_strings
      .map { date_string_parser.parse(_1) || nil }
      .compact.uniq
  end

  private

  attr_reader :date_string_parser
end

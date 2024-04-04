# frozen_string_literal: true

# Parses a comma-separated string of dates in the given format and returns an
# array of Date objects.
#
# @example
#   DateStringParser.new.parse("12/05/2022") #=> #<Date: 2022-05-12>
# @example
#   DateStringParser.for_database_format.parse("2022-05-12") #=> #<Date: 2022-05-12>
class DateStringParser
  def initialize(format = Format::UK.new)
    @format = format
  end

  class << self
    def for_database_format
      new(Format::Database.new)
    end
  end

  def parse(date_string)
    # if the string contains extra characters,
    # Date.strptime will parse the part of the string which looks like a date
    # and ignore the rest
    return false unless contains_only_date_characters(date_string)

    Date.strptime(date_string, format.format)
  rescue Date::Error
    false
  end

  private

  attr_reader :format

  def contains_only_date_characters(string)
    !!string.match(format.regexp)
  end

  module Format
    # @private
    class UK
      def format
        I18n.t("date.formats.default")
      end

      def regexp
        %r{^[0-9/]+$}
      end
    end

    # @private
    class Database
      def format
        Date::DATE_FORMATS[:db]
      end

      def regexp
        /^[0-9\-]+$/
      end
    end
  end
end

# frozen_string_literal: true

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
    class UK
      def format
        Date::DATE_FORMATS[:uk_date]
      end

      def regexp
        %r{^[0-9/]+$}
      end
    end

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

# frozen_string_literal: true

module Maps
  module Classes
    class DayParser
      class NonDayError < StandardError; end

      def self.name(date)
        I18n.l(date, format: "%A")
      end

      def self.parse(day_string, today = SOLDNTime.today)
        return unless day_string

        day = day_string.titlecase

        case day
        when "Today"      then name(today)
        when "Tomorrow"   then name(today + 1)
        when *DAYNAMES
          day
        else
          raise NonDayError, "Not a recognised day: #{day}"
        end
      end
    end
  end
end

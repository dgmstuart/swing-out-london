# frozen_string_literal: true

module Maps
  module Classes
    class Days
      def initialize(day_string, parser: Maps::Classes::DayParser)
        @day_string = day_string
        @parser = parser
      end

      def menu_days
        DAYNAMES.map do |day|
          MenuDay.new(day:, selected: day == selected_day)
        end
      end

      def selected_day
        parser.parse(day_string)
      end

      private

      attr_reader :day_string, :parser
    end
  end
end

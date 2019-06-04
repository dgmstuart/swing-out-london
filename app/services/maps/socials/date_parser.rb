# frozen_string_literal: true

module Maps
  module Socials
    class DateParser
      def self.parse(date_string, today)
        return unless date_string

        case date_string
        when 'today'      then today
        when 'tomorrow'   then today + 1
        else
          begin
            date_string.to_date
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end

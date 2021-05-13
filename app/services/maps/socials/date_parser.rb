# frozen_string_literal: true

module Maps
  module Socials
    class DateParser
      class << self
        def parse(date_string, today)
          return unless date_string

          case date_string
          when 'today'      then today
          when 'tomorrow'   then today + 1
          else
            safe_parse(date_string)
          end
        end

        def safe_parse(date_string)
          date_string.to_date
        rescue StandardError
          nil
        end
      end
    end
  end
end

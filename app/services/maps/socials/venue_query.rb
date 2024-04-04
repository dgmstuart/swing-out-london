# frozen_string_literal: true

module Maps
  module Socials
    class VenueQuery
      def venues(dates)
        events_on(dates).map(&:venue).uniq
      end

      private

      def events_on(dates)
        dates.inject([]) do |events, date|
          events + Event.socials_on_date(date)
        end
      end
    end
  end
end

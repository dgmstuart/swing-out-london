# frozen_string_literal: true

module Maps
  module Socials
    # Query object for returning {Venue}s which have social dances somewhere in
    # the given list of dates.
    class VenueQuery
      def venues(dates)
        events_on(dates).map(&:venue).uniq
      end

      private

      def events_on(dates)
        dates.flat_map { |date| Event.socials_on_date(date) }
      end
    end
  end
end

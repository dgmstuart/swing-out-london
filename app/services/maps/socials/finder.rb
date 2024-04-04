# frozen_string_literal: true

module Maps
  module Socials
    # Responsible for finding the list of {Event}s with social dances happening
    # at a {Venue} during the listing period, grouped by date.
    class Finder
      def initialize(date:)
        @date = date
      end

      def find_for_venue(venue)
        SocialsListings.for_map(venue).build(dates)
      end

      private

      def dates
        return SOLDNTime.listing_dates unless date

        [date]
      end

      attr_reader :date
    end
  end
end

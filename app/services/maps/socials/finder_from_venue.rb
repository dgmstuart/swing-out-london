# frozen_string_literal: true

module Maps
  module Socials
    class FinderFromVenue
      def initialize(date:)
        @date = date
      end

      def find(venue)
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

# frozen_string_literal: true

module Maps
  module Socials
    class FinderFromVenue
      def initialize(date:, today:)
        @date = date
        @today = today
      end

      def find(venue)
        dates =
          if date
            [date]
          else
            Event.listing_dates(today)
          end

        SocialsListings.for_venue(venue).build(dates)
      end

      private

      attr_reader :date, :today
    end
  end
end

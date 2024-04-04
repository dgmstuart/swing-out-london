# frozen_string_literal: true

module Maps
  module Classes
    # Responsible for finding the list of {Event}s with dance classes happening
    # at a {Venue} during the listing period.
    class Finder
      def initialize(day:)
        @day = day
      end

      def find_for_venue(venue)
        if day
          Event.listing_classes_on_day_at_venue(day, venue).includes(:class_organiser)
        else
          Event.listing_classes_at_venue(venue).includes(:class_organiser)
        end
      end

      private

      attr_reader :day
    end
  end
end

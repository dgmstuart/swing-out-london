# frozen_string_literal: true

module Maps
  module Classes
    class VenueQuery
      def initialize(day)
        @day = day
      end

      def venues
        if day
          Venue.all_with_classes_listed_on_day(day)
        else
          Venue.all_with_classes_listed
        end
      end

      private

      attr_reader :day
    end
  end
end

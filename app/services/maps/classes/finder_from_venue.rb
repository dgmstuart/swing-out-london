# frozen_string_literal: true

module Maps
  module Classes
    class FinderFromVenue
      def initialize(day:)
        @day = day
      end

      def find(venue)
        # TODO: ADD IN CANCELLATIONS!
        if day
          Event.listing_classes_on_day_at_venue(day, venue).includes(:class_organiser, :swing_cancellations)
        else
          Event.listing_classes_at_venue(venue).includes(:class_organiser, :swing_cancellations)
        end
      end

      private

      attr_reader :day
    end
  end
end

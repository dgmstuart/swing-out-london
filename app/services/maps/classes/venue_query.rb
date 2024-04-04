# frozen_string_literal: true

module Maps
  module Classes
    class VenueQuery
      def venues(day)
        if day
          Venue.all_with_classes_listed_on_day(day)
        else
          Venue.all_with_classes_listed
        end
      end
    end
  end
end

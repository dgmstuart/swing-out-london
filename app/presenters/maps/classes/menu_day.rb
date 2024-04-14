# frozen_string_literal: true

module Maps
  module Classes
    # Presenter for the map sidebar menu which lists the days of the week
    class MenuDay
      def initialize(day:, selected:)
        @day = day
        @selected = selected
      end

      def to_s
        @day.pluralize
      end

      def to_param
        @day
      end

      def selected?
        @selected
      end

      def events?
        Event.listing_classes_on_day(@day).exists?
      end
    end
  end
end

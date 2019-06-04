# frozen_string_literal: true

module Maps
  module Socials
    class VenueQuery
      def initialize(display_dates)
        @display_dates = display_dates
      end

      def venues
        events.map(&:venue).uniq
      end

      private

      attr_reader :display_dates

      def events
        display_dates.inject([]) do |events, date|
          events + Event.socials_on_date(date)
        end
      end
    end
  end
end

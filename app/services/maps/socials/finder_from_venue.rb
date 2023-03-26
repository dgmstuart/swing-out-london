# frozen_string_literal: true

module Maps
  module Socials
    class FinderFromVenue
      def initialize(date:, today:)
        @date = date
        @today = today
      end

      def find(venue)
        if date
          [[date, Event.socials_on_date(date, venue), Event.cancelled_on_date(date)]]
        else
          Event.socials_dates(today, venue)
        end
      end

      private

      attr_reader :date, :today
    end
  end
end

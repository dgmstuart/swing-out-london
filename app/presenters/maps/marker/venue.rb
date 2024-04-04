# frozen_string_literal: true

module Maps
  module Marker
    # Presenter for displaying {Venue}s in map marker info windows
    class Venue
      def initialize(venue)
        @venue = venue
      end

      delegate :name, to: :venue
      delegate :postcode, to: :venue

      def url
        venue.website
      end

      def address_lines
        venue.address.split(",").map(&:strip).tap do |lines|
          lines.delete("London")
        end
      end

      private

      attr_reader :venue
    end
  end
end

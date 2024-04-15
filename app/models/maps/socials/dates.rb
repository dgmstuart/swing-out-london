# frozen_string_literal: true

module Maps
  module Socials
    class Dates
      class DateOutOfRangeError < StandardError; end

      def initialize(date_string, today = SOLDNTime.today)
        @date_string = date_string
        @today = today
      end

      def menu_dates
        listing_dates.map do |date|
          MenuDate.new(date:, selected: date == selected_date)
        end
      end

      def display_dates
        if date_string
          [date]
        else
          listing_dates
        end
      end

      def selected_date
        date if date_string
      end

      private

      attr_reader :date_string, :today

      def listing_dates
        SOLDNTime.listing_dates
      end

      def date
        DateParser.parse(date_string, today).tap do |date|
          raise DateOutOfRangeError unless listing_dates.include?(date)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Maps
  class MarkerInfo
    def initialize(venue:, events:)
      @venue = venue
      @events = events
    end

    delegate :name, to: :venue, prefix: true
    delegate :postcode, to: :venue

    def venue_url
      venue.website
    end

    def address_lines
      venue.address.split(",").map(&:strip).tap do |lines|
        lines.delete("London")
      end
    end

    def social_listings_rows
      events.inject([]) do |listings, (date, social_listings_on_date)|
        listings + social_listings_on_date.map do |social_listing|
          SocialListingsRow.new(date, social_listing)
        end
      end
    end

    def class_listings
      events.inject([]) do |listings, event|
        listings << ClassListing.new(event)
      end
    end

    private

    attr_reader :venue, :events

    class SocialListingsRow
      def initialize(date, social_listing)
        @date = date
        @social_listing = social_listing
      end

      attr_reader :social_listing

      def date
        @date.to_s(:listing_date)
      end
    end
  end

  class ClassListing
    def initialize(event)
      @event = event
    end

    attr_reader :event

    def day
      event.day.pluralize
    end
  end
end

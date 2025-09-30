# frozen_string_literal: true

module Maps
  module Marker
    # Glues together listings info for a map marker for a {Venue} by fetching a
    # list of {Events} and wrapping each one in the appropriate presenter.
    class ListingsBuilder
      def initialize(event_finder:, listings_builder:)
        @event_finder = event_finder
        @listings_builder = listings_builder
      end

      class << self
        def for_classes(day:)
          event_finder = Classes::Finder.new(day:)
          listings_builder = ClassListings.new
          new(event_finder:, listings_builder:)
        end

        def for_socials(date:)
          event_finder = Socials::Finder.new(date:)
          listings_builder = SocialInstanceListings.new
          new(event_finder:, listings_builder:)
        end
      end

      def build(venue)
        events = event_finder.find_for_venue(venue)
        listings_builder.build(events)
      end

      private

      attr_reader :event_finder, :listings_builder

      # @private
      class SocialInstanceListings
        def build(events)
          events.flat_map do |(date, social_listings_on_date)|
            social_listings_on_date.map do |social_listing|
              SocialInstanceListing.new(date, social_listing)
            end
          end
        end
      end

      # @private
      class SocialInstanceListing
        def initialize(date, social_listing)
          @date = date
          @social_listing = social_listing
        end

        attr_reader :social_listing

        def date
          I18n.l(@date, format: :listing_date)
        end
      end

      # @private
      class ClassListings
        def build(events)
          events.flat_map do |event|
            ClassListing.new(event)
          end
        end
      end

      # @private
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
  end
end

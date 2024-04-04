# frozen_string_literal: true

module Maps
  class MarkerInfoBuilder
    def initialize(event_finder:, presenter_klass: Maps::MarkerInfo)
      @event_finder = event_finder
      @presenter_klass = presenter_klass
    end

    class << self
      def for_classes(day:)
        event_finder = Maps::Classes::Finder.new(day:)
        new(event_finder:)
      end

      def for_socials(date:)
        event_finder = Maps::Socials::Finder.new(date:)
        new(event_finder:)
      end
    end

    def build(venue)
      events = event_finder.find_for_venue(venue)
      presenter_klass.new(venue:, events:)
    end

    private

    attr_reader :event_finder, :presenter_klass
  end
end

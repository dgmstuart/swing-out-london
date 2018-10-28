# frozen_string_literal: true

class MapsController < ApplicationController
  layout 'map'

  caches_action :socials, :classes,
                cache_path: proc { |c| c.params.permit(:day, :date, :venue_id) },
                layout: true,
                expires_in: 1.hour,
                race_condition_ttl: 10

  def classes
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'

    # Days are stored in the database in titlecase - also in the DAYNAMES constant
    begin
      @day = get_day(params[:day])
    rescue NonDayError
      flash[:warn] = 'We can only show you classes for days of the week'
      logger.warn("Not a recognised day: #{@day}")
      redirect_to map_classes_path
      return
    end

    venues = if @day
               Venue.all_with_classes_listed_on_day(@day)
             else
               Venue.all_with_classes_listed
             end

    @map =
      if venues.blank?
        EmptyMap.new
      else
        Map.new(
          venues: venues,
          highlighted_venue_id: params[:venue_id],
          event_finder: ClassesFinderFromVenue.new(day: @day),
          info_window_partial: 'classes_map_info',
          renderer: self
        )
      end
  end

  def socials
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'

    @listing_dates = Event.listing_dates(today)

    if params[:date].blank?
      # show events for all dates
      events = Event.socials_dates(today).map { |s| s[1] }.flatten
    else
      @date = get_date(params[:date])

      if @listing_dates.include?(@date)
        events = Event.socials_on_date(@date)
      else
        flash[:warn] = 'We can only show you events for the next 14 days'
        logger.warn("Not a date in the visible range: #{@date}")
        redirect_to map_socials_path
        return
      end
    end

    @map =
      if events.nil?
        EmptyMap.new
      else
        venues = events.map(&:venue).uniq
        Map.new(
          venues: venues,
          highlighted_venue_id: params[:venue_id],
          event_finder: SocialsFinderFromVenue.new(date: @date, today: today),
          info_window_partial: 'socials_map_info',
          renderer: self
        )
      end
  end

  private

  # TODO: get_day and get_date maybe don't belong here...

  class NonDayError < StandardError; end
  # Return a Capitalised string IF the input refers to a valid listing day
  def get_day(day_string)
    return unless day_string

    day = day_string.titlecase

    case day
    when 'Today'      then Event.weekday_name(today)
    when 'Tomorrow'   then Event.weekday_name(today + 1)
    when *DAYNAMES
      day
    else
      raise NonDayError, "Not a recognised day: #{day}"
    end
  end

  # Return a Date IF the input refers to a valid listing date
  def get_date(date_string)
    return unless date_string

    case date_string
    when 'today'      then today
    when 'tomorrow'   then today + 1
    else
      begin
        date_string.to_date
      rescue StandardError
        nil
      end
    end
  end

  class Map
    attr_reader :highlighted_venue

    def initialize(venues:, highlighted_venue_id:, event_finder:, info_window_partial:, renderer:)
      @venues = venues
      @highlighted_venue_id = highlighted_venue_id
      @event_finder = event_finder
      @info_window_partial = info_window_partial
      @renderer = renderer
    end

    def options
      { 'zoom' => 14, 'auto_zoom' => false } if venues.count == 1
    end

    def json
      venues.to_gmaps4rails do |venue, marker|
        marker.infowindow render_info_window(venue)

        # N.B. If the given ID doesn't match any of those venues, just ignore it #TODO - should maybe be 404 instead?
        @highlighted_venue = venue if venue_is_highlighted?(venue)
        marker.json(marker_json(venue))
      end
    end

    private

    attr_reader :venues, :highlighted_venue_id, :event_finder, :info_window_partial, :renderer

    def marker_json(venue)
      { id: venue.id, title: venue.name }.tap do |json_options|
        highlighted_marker = 'https://maps.google.com/mapfiles/marker_purple.png'
        json_options[:picture] = highlighted_marker if venue_is_highlighted?(venue)
      end
    end

    def venue_is_highlighted?(venue)
      venue.id.to_s == highlighted_venue_id
    end

    def render_info_window(venue)
      renderer.render_to_string(partial: info_window_partial, locals: { venue: venue, events: event_finder.find(venue) })
    end
  end

  class ClassesFinderFromVenue
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

  class SocialsFinderFromVenue
    def initialize(date:, today:)
      @date = date
      @today = today
    end

    def find(venue)
      if date
        [Event.socials_on_date(date, venue), Event.cancelled_events_on_date(date)]
      else
        Event.socials_dates(today, venue)
      end
    end

    private

    attr_reader :date, :today
  end

  class EmptyMap
    def json
      {}
    end

    def options
      {
        center_latitude: 51.5264,
        center_longitude: -0.0878,
        zoom: 11
      }
    end

    def highlighted_venue
      nil
    end
  end
end

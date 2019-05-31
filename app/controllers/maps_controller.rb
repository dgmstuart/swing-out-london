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

    begin
      @day = Maps::Classes::DayParser.parse(params[:day], today)
    rescue Maps::Classes::DayParser::NonDayError
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
        Maps::EmptyMap.new
      else
        Maps::GmapsMap.new(
          venues: venues,
          highlighted_venue_id: params[:venue_id],
          event_finder: Maps::Classes::FinderFromVenue.new(day: @day),
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
      @date = Maps::Socials::DateParser.parse(params[:date], today)

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
        Maps::EmptyMap.new
      else
        venues = events.map(&:venue).uniq
        Maps::GmapsMap.new(
          venues: venues,
          highlighted_venue_id: params[:venue_id],
          event_finder: Maps::Socials::FinderFromVenue.new(date: @date, today: today),
          info_window_partial: 'socials_map_info',
          renderer: self
        )
      end
  end
end

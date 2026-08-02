# frozen_string_literal: true

class MapsController < ApplicationController
  layout "map"

  around_action :cache_map, only: %i[socials classes]

  def classes
    day_string = params[:day]
    @days = Maps::Classes::Days.new(day_string)
    @map_markers =
      Maps::Markers.for_classes(
        selected_day: @days.selected_day,
        renderer: self
      ).for_venues(
        venues: Maps::Classes::VenueQuery.new.venues(@days.selected_day),
        highlighted_venue_id:
      )
  rescue Maps::Classes::DayParser::NonDayError
    logger.warn("Not a recognised day: #{day_string}")
    redirect_to map_classes_path
  end

  def socials
    @map_dates = Maps::Socials::Dates.new(params[:date])
    @map_markers =
      Maps::Markers.for_socials(
        selected_date: @map_dates.selected_date,
        renderer: self
      ).for_venues(
        venues: Maps::Socials::VenueQuery.new.venues(@map_dates.display_dates),
        highlighted_venue_id:
      )
  rescue Maps::Socials::Dates::DateOutOfRangeError
    logger.warn("Not a date in the visible range: #{@date}")
    redirect_to map_socials_path, status: :moved_permanently
  end

  def cache_map(&)
    cache_action(action_cache_key, &)
  end

  def action_cache_key
    values = params.values_at(:controller, :action, :day, :date, :venue_id).compact
    values << Audit.last.cache_key if Audit.any?
    values.join("-")
  end

  private

  def highlighted_venue_id = params[:venue_id].to_i
end

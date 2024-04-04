# frozen_string_literal: true

class MapsController < ApplicationController
  layout "map"

  caches_action :socials, :classes,
                cache_path: ->(c) { c.action_cache_key },
                layout: true,
                expires_in: 1.hour,
                race_condition_ttl: 10

  def classes
    @day = Maps::Classes::DayParser.parse(params[:day])
    @map_markers =
      Maps::Markers.for_classes(
        selected_day: @day,
        renderer: self
      ).for_venues(
        venues: Maps::Classes::VenueQuery.new(@day).venues,
        highlighted_venue_id: params[:venue_id].to_i
      )
  rescue Maps::Classes::DayParser::NonDayError
    logger.warn("Not a recognised day: #{@day}")
    redirect_to map_classes_path
  end

  def socials
    @map_dates = Maps::Socials::Dates.new(params[:date])
    @map_markers =
      Maps::Markers.for_socials(
        selected_date: @map_dates.selected_date,
        renderer: self
      ).for_venues(
        venues: Maps::Socials::VenueQuery.new(@map_dates.display_dates).venues,
        highlighted_venue_id: params[:venue_id].to_i
      )
  rescue Maps::Socials::Dates::DateOutOfRangeError
    logger.warn("Not a date in the visible range: #{@date}")
    redirect_to map_socials_path, status: :moved_permanently
  end

  def action_cache_key
    values = params.values_at(:controller, :action, :day, :date, :venue_id).compact
    values << Audit.last.cache_key if Audit.any?
    values.join("-")
  end
end

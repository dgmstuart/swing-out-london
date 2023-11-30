# frozen_string_literal: true

module EventsHelper
  # ------- #
  # SELECTS #
  # ------- #

  def venue_select
    Venue.order(name: :asc).collect { |v| [v.name_and_area, v.id] }
  end

  def organiser_select
    Organiser.all.collect { |o| [o.name, o.id] }
  end

  # ----- #
  # LINKS #
  # ----- #

  def organiser_link(organiser)
    return "Unknown" if organiser.nil?

    link_to_unless organiser.website.nil?, organiser.name, organiser.website
  end

  def venue_link(event)
    link_to_unless event.venue.website.nil?, event.venue.name, event.venue.website
  end
end

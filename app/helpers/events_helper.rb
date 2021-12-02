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

  def event_type_select
    [
      ['School (organised by a dance school)', 'school'],
      ['Dance Club (organised for dancers)', 'dance_club'],
      ['Vintage Club (not aimed at dancers)', 'vintage_club'],
      ['Gig (not aimed at dancers)', 'gig'],
      ['Festival (part of a larger event)', 'festival']
    ].freeze
  end

  # ----- #
  # LINKS #
  # ----- #

  def organiser_link(organiser)
    return Event::UNKNOWN_ORGANISER if organiser.nil?

    link_to_unless organiser.website.nil?, organiser.name, organiser.website
  end

  def venue_link(event)
    return event.blank_venue if event.venue.nil?

    link_to_unless event.venue.website.nil?, event.venue.name, event.venue.website
  end

  # --- #
  # CMS #
  # --- #

  def action_links(anchors)
    tag.p(class: 'actions_panel') do
      string = link_to 'New event', new_event_path
      anchors.each do |a|
        string += ' -- '
        string += link_to a.to_s, anchor: a
      end
      string
    end
  end
end

# frozen_string_literal: true

module VenuesHelper
  # Assign a class to a venue row to show whether it has events in date or not
  def venue_row_tag(venue)
    if venue.all_events_out_of_date?
      class_string = 'all_out_of_date'
    elsif venue.all_events_nearly_out_of_date?
      class_string = 'all_near_out_of_date'
    end
    tag :tr, { class: class_string, id: "venue_#{venue.id}" }, true
  end
end

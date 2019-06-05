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

  def conditional_delete_tag(venue)
    confirmation = 'Are you sure you want to delete this venue?'
    link_to_if venue.can_delete?, 'Delete', venue, confirm: confirmation, method: :delete do
      content_tag :span, "Can't be deleted: has associated events", class: 'inactive'
    end
  end
end

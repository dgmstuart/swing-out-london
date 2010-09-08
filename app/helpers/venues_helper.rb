module VenuesHelper
  
  def compass_dropdown(f)
    f.select :compass, COMPASS_POINTS, {:include_blank => true}
  end
  
  # Assign a class to a venue row to show whether it has events in date or not
  def venue_row_tag(venue) 
    if venue.all_events_out_of_date?
      class_string = "all_out_of_date"
    elsif venue.all_events_nearly_out_of_date?
      class_string = "all_near_out_of_date"
    end
    tag :tr, {:class => class_string}, true
  end
end

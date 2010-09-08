module OrganisersHelper
  
  # Assign a class to an organiser row to show whether it has events in date or not
  def organiser_row_tag(organiser) 
    if organiser.all_events_out_of_date?
      class_string = "all_out_of_date"
    elsif organiser.all_events_nearly_out_of_date?
      class_string = "all_near_out_of_date"
    end
    tag :tr, {:class => class_string}, true
  end
end

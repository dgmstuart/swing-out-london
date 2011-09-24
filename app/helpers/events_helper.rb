module EventsHelper

  # ------------ #
  # LISTING ROWS #
  # ------------ #
  
  #move somewhere general?
  
  def day_row(d)
    if is_today(d)    
      html_options = {:class => "day_row today", :id => "classes_today" }
    else
      html_options = {:class => "day_row" }
    end
    
    tag :li, html_options, true
  end 
  
  def date_row(d)
    if is_today(d)    
      html_options = {:class => "date_row today", :id => "socials_today" }
    else
      html_options = {:class => "date_row" }
    end
    
    tag :li, html_options, true
  end
  
  #if there are no socials on this day, we need to add a class
  def socialsh2(&block)
    if Event.socials_today.empty?
      content_tag :h2, :id => "socials_today", &block
    else
      content_tag :h2, &block
    end
  end
  
  def is_today(d)
  	d.class == String && Event.weekday_name(Date.local_today) == d || 
    d.class == Date && d == Date.local_today
  end
  
  def is_tomorrow(d)
  	d.class == String && Event.weekday_name(Date.local_tomorrow) == d || 
    d.class == Date && d == Date.local_tomorrow
  end
  
  def today_label(d)
  	if is_today(d)
      content_tag :strong, "Today", :class => "today_label"
    end
  end
  
  def tomorrow_label(d)
  	if is_tomorrow(d)
      content_tag :strong, "Tomorrow", :class => "tomorrow_label"
    end
  end

  
  def classes_on_day(day)
    @classes.select {|e| e.day == day}
  end
    
  
  
  # ---------------- #
  # LISTING ELEMENTS #
  # ---------------- #
  
  def social_listing(social, date)
    if social.title.nil? || social.title.empty?
      logger.error "ERROR: tried to display Event (id = #{social.id}) without a title"
      return 
    end
    
    # Has the event been cancelled?
    # TODO: this approach requires multiple passes through the cancellation_array... find a more efficient way
    cancelled = social.cancellation_array.include?(date)
    
    listing_string = compass_point(social)
    # Add a label if the event is cancelled
    listing_string += content_tag( :strong, "Cancelled", :class => "cancelled_label" ) + " " if cancelled
    listing_string += social_link(social, date, cancelled)
    
    classstring = "social_cancelled" if cancelled
    return content_tag( :li, listing_string, :class => classstring)
  end
  
  def social_link(event, date, cancelled)
    event_title_class = "social_title"
    event_details_class = "social_details"
    
    #Highlight socials which are monthly or more infrequent:
    event_title_class += " social_highlight" if event.frequency == 0 || event.frequency >= 4
    
    event_title = event.title 
    #If this is empty, something has gone wrong, and we shouldn't be displaying anything. Catch this earlier.
    
    # We shouldn't have any blank fields, but if we do, then display as much as possible
    if event.venue.nil? || (event.venue.name.nil? && event.venue.area.nil?)
      event.blank_venue
    elsif event.venue.name.nil?
      #because of the conditions above, venue area is not nil
      event_details = event.venue.area 
    else
      event_details = event.venue.name
      event_details += (" in " + event.venue.area) unless event.venue.area.nil? 
    end  
    
    display = content_tag( :span, event_title, :class => event_title_class ) + " " + 
            content_tag( :span, event_details, :class => event_details_class )
    
    # display a link, or plain text if there is no url
    if event.url.nil?
        display
    else
      link_to display, event.url
    end
    
  end
  
  #TODO - looks like it could be put in a funky new class...
  def swingclass_listing(swingclass)
    if swingclass.title.nil? || swingclass.title.empty?
      logger.error "ERROR: tried to display Social Class (id = #{swingclass.id}) without a title"
      return 
    end
    
    content_tag( :li, compass_point(swingclass) + swingclass_link(swingclass) )
  end
  
  def swingclass_link(event)
    event_title_class = "swingclass_title"
    event_details_class = "swingclass_details"
    
    event_title = event.title 
    #If this is empty, something has gone wrong, and we shouldn't be displaying anything. Catch this earlier.
     
    # We shouldn't have any blank fields, but if we do, then display as much as possible
    if event.venue.nil? || event.venue.area.nil?
      event.blank_venue
    else
      #because of the conditions above, venue area is not nil
      event_details = event.venue.area 
    end  
    
    display = event_title + " in " + event_details
    
    # Add a label if the event is new
    display = "(from #{event.first_date.to_s(:short_date)}) " + display unless event.first_date.nil? || event.started?
    display = new_label + display if event.new?
    
    # display a link, or plain text if there is no url
    if event.url.nil?
      output = content_tag( :span, display, :class => event_title_class )
    else
      output = link_to( display, event.url, :class => event_title_class )
    end
    
    # Add a cancellation message to the end if there are any FUTURE cancellations
    output += swingclass_cancelledmsg(event) unless event.cancellation_array(true).empty? 
    
    return output
  end
  
  def new_label
    content_tag( :strong, "New!", :class => "new_label" )
  end
  
  # Return a span containing a compass point
  def compass_point(event)
    
    if event.venue.nil?
      title = Venue::UNKNOWN_AREA
      compass = Venue::UNKNOWN_COMPASS
      logger.warn "WARNING: Venue was nil for '#{event.title}' (event #{event.id})"
    else 
      title = event.venue.compass_text
      compass = event.venue.compass 
    end
         
    content_tag :abbr, :title => title, :class => "compass" do
      compass
    end
    
  end
  
  # Return a span containing a message about cancelled dates:
  def swingclass_cancelledmsg(swingclass)
    content_tag( :em, "Cancelled on #{swingclass.pretty_cancelled_dates}" , :class => "class_cancelled" )
  end
  
  # ------- #
  # DISPLAY #
  # ------- #
  
  def commas_as_lines(s)
    # insert newlines after each comma
    s.split(',').collect do |i|
      i.strip 
    end.join(",\n")
  end
  
  # Assign a class to an event row to show whether it is out of date or not
  def event_row_tag(event) 
    if event.ended? || (event.out_of_date && event.one_off?)
      class_string = "inactive"
    elsif event.out_of_date
      class_string = "out_of_date"
    elsif event.near_out_of_date
      class_string = "near_out_of_date"
    end
    tag :tr, {:class => class_string, :id => "event_#{event.id}"}, true
  end
  
  
  # ------- #
  # SELECTS #
  # ------- #
  
  def venue_select
    Venue.all(:order => "name").collect{ |v| [v.name_and_area,v.id] }
  end
  
  def organiser_select
    Organiser.all.collect{ |o| [o.name,o.id] }
  end
  
  def event_type_select
    Event::event_types
  end
  
  # ----- #
  # LINKS #
  # ----- #
  
  def organiser_link(event)
    return Event::UNKNOWN_ORGANISER if event.organiser.nil?
    link_to_unless event.organiser.website.nil?, event.organiser.name, event.organiser.website
  end
  
  def venue_link(event)
    return event.blank_venue if event.venue.nil?
    link_to_unless event.venue.website.nil?, event.venue.name, event.venue.website
  end
  
end

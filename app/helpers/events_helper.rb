module EventsHelper
  
  # ------------ #
  # LISTING ROWS #
  # ------------ #
  
  #move somewhere general?
  def row_tag(myclass, day=nil)       
   	tag :li, {:class => add_todayclass(myclass, day)}, true
  end
  
  # add an extra event if today is the target day or date
  def add_todayclass(myclass, d)
    myclass = myclass + " today" if is_today(d)
      
    return myclass
  end
  
  def is_today(d)
  	d.class == String && Event.weekday_name(Date.today) == d || 
    d.class == Date && d == Date.today
  end
  
  def is_tomorrow(d)
  	d.class == String && Event.weekday_name(Date.tomorrow) == d || 
    d.class == Date && d == Date.tomorrow
  end
  
  def today_label(d)
  	if is_today(d)
      content_tag :span, "Today", :class => "today_label"
    end
  end
  
  def tomorrow_label(d)
  	if is_tomorrow(d)
      content_tag :span, "Tomorrow", :class => "tomorrow_label"
    end
  end
  
  	
  
  
  # ---------------- #
  # LISTING ELEMENTS #
  # ---------------- #
  
  def social_listing(social)
    if social.title.nil? || social.title.empty?
      logger.error "ERROR: tried to display Event (id = #{social.id}) without a title"
      return 
    end
    
    compass_point(social) + social_link(social)
  end
  
  def social_link(event)
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
    
    if event.url.nil?
      display
    else
      link_to display, event.url, :class => "url"
    end
    
  end
  
  
  def swingclass_listing(swingclass)
    if swingclass.title.nil? || swingclass.title.empty?
      logger.error "ERROR: tried to display Social Class (id = #{swingclass.id}) without a title"
      return 
    end
    
    compass_point(swingclass) + swingclass_link(swingclass)
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
    
    if event.url.nil?
      content_tag( :span, display, :class => event_title_class )
    else
      link_to( display, event.url, :class => event_title_class )
    end
    
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
  
  # ------- #
  # DISPLAY #
  # ------- #
  
  def commas_as_lines(s)
    # insert newlines after each comma
    s.split(',').collect do |i|
      i.strip 
    end.join(",\n")
  end
  
  def display_date(date)
    date.strftime("%A #{date.day.ordinalize} %B") # e.g. "Sunday 2nd March"
  end
  
  # ------- #
  # SELECTS #
  # ------- #
  
  def venue_select
    Venue.find(:all, :order => "name").collect{ |v| [v.name_and_area,v.id] }
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

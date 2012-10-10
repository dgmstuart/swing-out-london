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
  
  def day_header(day)
    url_options = { controller: :maps, 
                        action: :classes, 
                           day: day }
    link_to day, url_options, title: "Click to view this day's weekly classes on a map" 
  end
  
  
  def date_header(date)
    display = ""
    display = "#{today_label} " if is_today(date)
    display = "#{tomorrow_label} " if is_tomorrow(date)
    display += date.to_s(:listing_date)
    
    url_options = { controller: :maps, 
                    action: :socials, 
                    date: date.to_s(:db) }
    link_to raw(display), url_options, title: "Click to view this date's events on a map" 
  end
  
  #if there are no socials on this day, we need to add a class
  def socialsh2(&block)
    if @socials_dates.empty?
      content_tag :h2, :id => "socials_today", &block
    else
      content_tag :h2, &block
    end
  end
  
  def is_today(d)
  	d.class == String && Event.weekday_name(@today) == d || 
    d.class == Date && d == @today
  end
  
  def is_tomorrow(d)
  	d.class == String && Event.weekday_name(@today + 1) == d || 
    d.class == Date && d == @today + 1
  end
  
  def today_label
  	content_tag :strong, "Today", :class => "today_label"
  end
  
  def tomorrow_label
    content_tag :strong, "Tomorrow", :class => "tomorrow_label"
  end

  
  def classes_on_day(day)
    @classes.select {|e| e.day == day}.sort{|e,v| e.venue.area <=> v.venue.area}
  end
    
  
  
  # ---------------- #
  # LISTING ELEMENTS #
  # ---------------- #
  
  def social_listing(social, cancelled, date)
    if social.title.nil? || social.title.empty?
      logger.error "[ERROR]: tried to display Event (id = #{social.id}) without a title"
      return 
    end
    
    cancelled_part = ""
    cancelled_part = cancelled_label + " " if cancelled
    
    map_url = "map/socials/#{date.to_s(:db)}/#{social.venue_id}" unless (social.venue.lat.nil? || social.venue.lng.nil?)
    postcode_part = outward_postcode(social, map_url)
    
    content_tag :li, 
      postcode_part + " " + 
      content_tag( :span, raw(cancelled_part + social_link(social)), :class => "social_details")
  end
  
  def social_link(event)    
    new_label =""
    new_label = new_event_label + " " if event.new?
    
    event_title = event.title
    #Highlight socials which are monthly or more infrequent:
    event_title =  content_tag( :span, event.title, :class => "social_highlight") if event.less_frequent?
    
    event_location = content_tag( :span, "#{event.venue_name} in #{event.venue_area}", :class => "social_info")
    
    #display = new_label + "#{event_title} - #{event_location}"
    display = raw(new_label + event_title + " - " + event_location)
            
    link_to_unless event.url.nil?, display, event.url
  end
  
  def mapinfo_social_listing(social, cancelled, date=nil)
    if social.title.nil? || social.title.empty?
      logger.error "[ERROR]: tried to display Event (id = #{social.id}) without a title"
      return 
    end
    
    date_info = ""
    if date
      date_part_content = link_to date.to_s(:listing_date), date: date.to_s(:db)
      date_info = content_tag :span, date_part_content + ": ", :class => "social_date"
    end
    
    cancelled_part = ""
    cancelled_part = cancelled_label + " " if cancelled
    
    class_info =""
    if social.has_class? || social.has_taster?
      class_style = ""
      class_style = " #{social.class_style}" unless social.class_style.blank?
      
      if social.has_class?
        class_type = "class"
      else 
        class_type = "taster"
      end
      
      school_info = "" 
      school_info = " by #{school_name(social)}" if school_name(social)
      
      class_info = " (with#{class_style} #{class_type}#{school_info})"
    end
    
    
    social_details = raw(cancelled_part + mapinfo_social_link(social)+ swingclass_info(class_info))
    social_details = content_tag :span, social_details, :class => "event_details" if date
    
    raw(date_info + social_details)
  end
  
  def mapinfo_social_link(event)    
    new_label =""
    new_label = new_event_label + " " if event.new?
    
    display = raw(new_label + event.title)
           
    link_to_unless event.url.nil?, display, event.url
  end
  
  def swingclass_listing(swingclass, day)
    map_url = "map/classes/#{day}/#{swingclass.venue_id}" unless (swingclass.venue.lat.nil? || swingclass.venue.lng.nil?)
    postcode_part = outward_postcode(swingclass, map_url)
    
    content_tag :li,
      postcode_part + " " + 
      content_tag( :span, swingclass_link(swingclass) + swingclass_cancelledmsg(swingclass), :class => "swingclass_details")
  end
  
  def swingclass_link(event)
    new_label = ""
    new_label = new_event_label + " " if event.new?
    
    start_date = ""
    start_date = " (from #{event.first_date.to_s(:short_date)})" unless event.first_date.nil? || event.started?
    
    class_style = ""
    class_style = " (#{event.class_style})" unless event.class_style.blank?
    
    course_length = ""
    course_length = " - #{event.course_length} week courses" unless event.course_length.nil?
    
    social_info = ""
    social_info = "at #{event.title} " if event.has_social?
    
    school_info = "" 
    school_info = "with #{school_name(event)}" if school_name(event)
    
    
    # TODO: work out why this needs the "raw" on the new_label to display properly
    display = raw(
      new_label +
      event.venue_area + start_date + class_style + course_length + " " +
      swingclass_info(social_info + school_info)
    )
    
    link_to_unless event.url.nil?, display, event.url
  end
  
  def mapinfo_swingclass_link(event)
    new_label = ""
    new_label = new_event_label + " " if event.new?

    start_date = ""
    start_date = " (from #{event.first_date.to_s(:short_date)})" unless event.first_date.nil? || event.started?

    class_type = " Class"
    class_type = " #{event.course_length} week courses" unless event.course_length.nil?
    
    class_style = ""
    class_style = " (#{event.class_style})" unless event.class_style.blank?
    
    social_info = ""
    social_info = "at #{event.title} " if event.has_social?

    school_info = "" 
    school_info = "with #{school_name(event)}" if school_name(event)


    # TODO: work out why this needs the "raw" on the new_label to display properly
    display = raw(
      new_label + start_date + 
      class_type + class_style + " " +
      swingclass_info(social_info + school_info)
    )

    link_to_unless event.url.nil?, display, event.url
  end
  
  def school_name(event)
    fail "Tried to get class-related info from an event with no class" unless event.has_class? || event.has_taster?
    return if event.class_organiser.nil?
    fail "Invalid Organiser (##{event.class_organiser.id}): name was blank" if event.class_organiser.name.blank?
    if event.class_organiser.shortname.blank?
      event.class_organiser.name
    else
      content_tag( :abbr, event.class_organiser.shortname, :title => event.class_organiser.name )
    end
  end

  def new_event_label
    content_tag( :strong, "New!", :class => "new_label" )
  end
  
  def cancelled_label
    content_tag( :strong, "Cancelled", :class => "cancelled_label" )
  end

  def swingclass_info(text)
    content_tag( :span, raw(text), :class => "swingclass_info" )
  end
  
  def outward_postcode(event, map_url=nil)
    # Default message:
    title = "Bah - this event is too secret to have a postcode!"
    
    if event.venue.nil?
      postcode = Venue::UNKNOWN_COMPASS
      logger.warn "[WARNING]: Venue was nil for '#{event.title}' (event #{event.id})"
    else 
      title = "#{ event.venue.postcode } to be precise. Click to see the venue on a map" unless event.venue.postcode.nil? || event.venue.postcode.empty?
      postcode = event.venue.outward_postcode
    end
        
    link_to_unless map_url.nil?, postcode, map_url, :title => title, :class => "postcode" do
      content_tag :abbr, postcode, :title => title, :class => "postcode"
    end
  end
  
  # Return a span containing a message about cancelled dates:
  def swingclass_cancelledmsg(swingclass)
    return "" if swingclass.cancellation_array(true).empty?
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
    content_tag :p, :class => "actions_panel" do 
      string = link_to 'New event', new_event_path
      anchors.each do |a|
        string += " -- "
        string += link_to "#{a}", :anchor => a
      end
      string
    end
  end
  
end

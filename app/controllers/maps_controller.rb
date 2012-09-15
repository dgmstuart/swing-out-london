class MapsController < ApplicationController
  
  def map
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    if params[:type]
      case params[:type].downcase.to_sym
      when :classes
        # Days are stored in the database in titlecase - also in the DAYNAMES constant
        day = case params[:day] 
              when "today"      then Event.weekday_name(today)
              when "tomorrow"   then Event.weekday_name(today + 1)
              when "yesterday"  then Event.weekday_name(today - 1)
              else params[:day]
              end
          
        events =  if day && DAYNAMES.include?(day.titlecase)
                      Event.active.weekly_or_fortnightly.classes.where(day: day.titlecase).includes(:venue, :organiser, :swing_cancellations)
                  else
                    Event.active.weekly_or_fortnightly.classes.includes(:venue, :organiser, :swing_cancellations)
                  end
      when :socials
        date =  case params[:date]
                when "today"      then today
                when "tomorrow"   then today + 1
                when "yesterday"  then today - 1
                else params[:date].to_date rescue nil
                end
        
        events =  if date && Event.listing_dates(today).include?(date)
                    Event.socials_on_date(date)
                  else 
                    Event.socials_dates(today).collect{ |a| a[1] }.flatten
                  end   
      end        
    end
    
    unless events
      # Either no "type" was supplied, or the type was invalid
      events = Event.active.weekly_or_fortnightly.classes + Event.socials_dates(today).collect{ |a| a[1] }.flatten
    end
     
    venues = events.map{ |e| e.venue }.uniq unless events.nil?  
          
    
    @map = Cartographer::Gmap.new( 'map', :type => :roadmap )
    
    @map.center  = CENTRAL_LONDON
    
    # If a venue was specified, centre on that venue
    if !params[:id].nil?
      venue = Venue.find(params[:id])
      unless venue.nil?
        unless venue.position.nil?
          @map.center = venue.position
        else
          logger.error "[ERROR]: 'position' was nil when trying to center map on venue id #{params[:id]}"
        end
      end
    end
    
    @map.zoom = 12
    @map.showtubes = (params[:tubes]=="y")
    @map.controls << :type
    @map.controls << :large
    @map.controls << :overview
    
    @icon = Cartographer::Gicon.new
    @map.icons << @icon
    
    venues.each do |venue|
    
      unless venue.position.nil?
        @map.markers << Cartographer::Gmarker.new(
          :name => "venue_#{venue.id}",
          :title => venue.name,
          :position => venue.position,
          :info_window_url => venue_map_info_url(venue.id),
          #:info_window_open => true,
          :icon => @icon
        )
      else
        logger.error "[ERROR]: 'position' was nil when trying to plot a marker for venue id #{venue.id}: #{venue.name}"
      end
    end
        
    @classes = Event.class_listing
    
    render :layout => 'map'
  end
  
  def venue_map_info
    @venue = Venue.find(params[:id])
    @events = @venue.events
    render :layout => false
  end

end

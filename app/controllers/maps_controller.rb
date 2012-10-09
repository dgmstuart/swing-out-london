class MapsController < ApplicationController
  layout "map" 
  
  caches_action :socials, :classes, cache_path: Proc.new { |c| c.params }, layout: true, :expires_in => 1.hour, :race_condition_ttl => 10
  
  def classes
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    # Days are stored in the database in titlecase - also in the DAYNAMES constant
    day = case params[:day] 
          when "today"      then Event.weekday_name(today)
          when "tomorrow"   then Event.weekday_name(today + 1)
          when "yesterday"  then Event.weekday_name(today - 1)
          else params[:day].titlecase unless params[:day].nil?
          end
      
    venues =  if day && DAYNAMES.include?(day)
                @day = day
                Venue.where(:id => Event.listing_classes.where(day: @day).select("distinct venue_id"))
              else
                Venue.where(:id => Event.listing_classes.select("distinct venue_id"))
              end

    if venues.nil? 
      empty_map
    else
      @json = venues.to_gmaps4rails do |venue, marker|
                # TODO: ADD IN CANCELLATIONS!
                venue_events =  if @day 
                                  Event.listing_classes.where(day: @day).where(venue_id: venue.id).includes(:class_organiser, :swing_cancellations)
                                else
                                  Event.listing_classes.where(venue_id: venue.id).includes(:class_organiser, :swing_cancellations)
                                end

                marker.infowindow render_to_string(:partial => "classes_map_info", :locals => { venue: venue, events: venue_events })
                json_options =  { id: venue.id, title: venue.name}
                json_options.merge!coloured_marker_json_options(:green) if venue.id.to_s == params[:id]
                marker.json(json_options)
      end
    end
  end
  
  def socials
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    @listing_dates = Event.listing_dates(today)
    
    date =  case params[:date]
            when "today"      then today
            when "tomorrow"   then today + 1
            when "yesterday"  then today - 1
            else params[:date].to_date rescue nil
            end
    
    events =  if date && @listing_dates.include?(date)
                @date = date
                Event.socials_on_date(date)
              else 
                Event.socials_dates(today).map{ |s| s[1] }.flatten
              end
    
    if events.nil? 
      empty_map
    else
      @map_options = { "zoom" => 14, "auto_zoom" => false } if events.count == 1
        
      venues = events.map{ |e| e.venue }.uniq
        
      @json = venues.to_gmaps4rails do |venue, marker|
        
        venue_events =  if @date
                          [Event.socials_on_date(date, venue), Event.cancelled_events_on_date(date)]
                        else 
                          Event.socials_dates(today, venue)
                        end

        marker.infowindow render_to_string(:partial => "socials_map_info", :locals => { venue: venue, events: venue_events })
        
        json_options =  { id: venue.id, title: venue.name}
        json_options.merge!coloured_marker_json_options(:green) if venue.id.to_s == params[:id]
        marker.json(json_options)
      end
    end
  end
  
  private
  
  def coloured_marker_json_options(colour)
    if [  :black,
          :grey,
          :white,
          :orange,
          :yellow,
          :purple,
          :green].include?(colour)
      { picture: "http://maps.google.com/mapfiles/marker_#{colour.to_s}.png",
        shadow_picture: 'http://maps.google.com/mapfiles/shadow50.png', 
        shadow_width: 37, 
        shadow_height: 34,
        shadow_anchor: [10,34], # Icon is 20x34, and the anchor is in the middle (10px) at the bottom (34px)
      }
    elsif [ :blue,
            :ltblue,
            #:red # Black outline
            #:green, # A lighter green
            #:yellow, # A lighter yellow
            #:purple, # A lighter purple
            :pink].include?(colour)
      { picture: "https://maps.gstatic.com/mapfiles/ms2/micons/#{colour.to_s}-dot.png",
        width: 32,
        height: 32,
        shadow_picture: 'https://maps.gstatic.com/mapfiles/ms2/micons/msmarker.shadow.png', 
        shadow_width: 59, 
        shadow_height: 32,
        shadow_anchor: [16,32],}
    else
      fail "Tried to created a marker with an invalid colour: #{colour}"
    end
    
    
  end
  
  def empty_map
    @json = {}
    @map_options =  { center_latitude: 51.51985,
                      center_longitude: -0.06729,
                      zoom: 11
                    }      
  end
end

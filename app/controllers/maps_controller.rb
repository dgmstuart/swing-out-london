class MapsController < ApplicationController
  layout "map"
  
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
      
    events =  if day && DAYNAMES.include?(day)
                @day = day
                Event.listing_classes.where(day: @day).includes(:venue)
              else
                Event.listing_classes.includes(:venue)
              end

    if events.nil? 
      empty_map
    else
      venues = events.map{ |e| e.venue }.uniq

      @json = venues.to_gmaps4rails do |venue, marker|
                # TODO: ADD IN CANCELLATIONS!
                venue_events =  if @day 
                                  Event.listing_classes.where(day: @day).where(venue_id: venue.id).includes(:organiser, :swing_cancellations)
                                else
                                  Event.listing_classes.where(venue_id: venue.id).includes(:organiser, :swing_cancellations)
                                end

                marker.infowindow render_to_string(:partial => "venue_map_info", :locals => { venue: venue, events: venue_events })
                marker.json({ :id => venue.id, :title => venue.name })
      end
    end
  end
  
  def socials
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    @listing_dates = Event.listing_dates(today)
    
    @type = :socials # in case type was nil or invalid
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
                Event.socials_dates(today).collect{ |a| a[1] }.flatten
              end
    
    if events.nil? 
      empty_map
    else
      venues = events.map{ |e| e.venue }.uniq

      @json = venues.to_gmaps4rails do |venue, marker|
        
        # TODO: DO THIS PROPERLY! AND INCLUDE CANCELLATIONS!
        venue_events = events.select{ |e| e.venue == venue }.uniq

        marker.infowindow render_to_string(:partial => "venue_map_info", :locals => { venue: venue, events: venue_events })
        marker.json({ :id => venue.id, :title => venue.name })
      end
    end
  end
  
  private
  
  def empty_map
    @json = {}
    @map_options =  { center_latitude: 51.51985,
                      center_longitude: -0.4,
                      zoom: 10
                    }      
  end
end

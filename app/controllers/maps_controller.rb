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
                  Event.active.weekly_or_fortnightly.classes.where(day: @day).includes(:venue, :organiser, :swing_cancellations)
              else
                Event.active.weekly_or_fortnightly.classes.includes(:venue, :organiser, :swing_cancellations)
              end
    
    create_map(events)
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
    create_map(events)
  end
  
  private
  
  def create_map(events)
    if events.nil? 
      @json = {}
      @map_options =  { center_latitude: 51.51985,
                        center_longitude: -0.4,
                        zoom: 10
                      }      
    else
      venues = events.map{ |e| e.venue }.uniq
      
      @json = venues.to_gmaps4rails do |venue, marker|
        
        #TODO: this is a horribly inefficient way of calculating this array of events - redesign the whole method/approach
        #TODO: add in cancelled
        venue_events = events.select{ |e| e.venue == venue }.uniq
        
        marker.infowindow render_to_string(:partial => "venue_map_info", :locals => { venue: venue, events: venue_events })
        marker.json({ :id => venue.id, :title => venue.name })
      end
    end
  end

end

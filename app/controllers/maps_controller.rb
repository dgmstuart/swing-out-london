class MapsController < ApplicationController
  
  def map
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
    @listing_dates = Event.listing_dates(today)
    
    @type = params[:type].downcase.to_sym if params[:type]
    case @type
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
    else # :socials or invalid type
      @type = :socials # in case type was nil or invalid
      date =  case params[:date]
              when "today"      then today
              when "tomorrow"   then today + 1
              when "yesterday"  then today - 1
              else params[:date].to_date rescue nil
              end
      
      events =  if date && @listing_dates.include?(date)
                  Event.socials_on_date(date)
                else 
                  Event.socials_dates(today).collect{ |a| a[1] }.flatten
                end
    # else # no type or invalid type
    #   @type = nil
    #   events = Event.active.weekly_or_fortnightly.classes + Event.socials_dates(today).collect{ |a| a[1] }.flatten
    end
    
    if events.nil? 
      @json = {}
      @map_options =  { center_latitude: 51.51985,
                        center_longitude: -0.4,
                        zoom: 10
                      }      
    else
      venues = events.map{ |e| e.venue }.uniq
      
      @json = venues.to_gmaps4rails do |venue, marker|
        marker.infowindow render_to_string(:partial => "venue_map_info", :locals => { venue: venue })
        marker.json({ :id => venue.id, :title => venue.name })
      end
    end
    
    render :layout => 'map'
  end

end

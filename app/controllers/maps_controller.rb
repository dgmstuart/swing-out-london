class MapsController < ApplicationController
  layout "map"

  caches_action :socials, :classes, cache_path: Proc.new { |c| c.params }, layout: true, :expires_in => 1.hour, :race_condition_ttl => 10

  def classes
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'

    # Days are stored in the database in titlecase - also in the DAYNAMES constant
    begin
      @day = get_day(params[:day])
    rescue NonDayError
      flash[:warn] = 'We can only show you classes for days of the week'
      logger.warn("Not a recognised day: #{@day}")
      redirect_to map_classes_path
      return
    end

    venues =  if @day
                Venue.all_with_classes_listed_on_day(@day)
              else
                Venue.all_with_classes_listed
              end


    if venues.blank?
      empty_map
    else
      @map_options = { "zoom" => 14, "auto_zoom" => false } if venues.count == 1

      @json = venues.to_gmaps4rails do |venue, marker|
                # TODO: ADD IN CANCELLATIONS!
                venue_events =  if @day
                                  Event.listing_classes_on_day_at_venue(@day,venue).includes(:class_organiser, :swing_cancellations)
                                else
                                  Event.listing_classes_at_venue(venue).includes(:class_organiser, :swing_cancellations)
                                end

                marker.infowindow render_to_string(:partial => "classes_map_info", :locals => { venue: venue, events: venue_events })
                json_options =  { id: venue.id, title: venue.name}
                if venue.id.to_s == params[:venue_id]
                  json_options.merge!coloured_marker_json_options(:green)
                end
                marker.json(json_options)
      end

      @highlighted_venue = Venue.find(params[:venue_id]) if params[:venue_id]
    end
  end

  def socials
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'

    @listing_dates = Event.listing_dates(today)

    if params[:date].blank?
      # show events for all dates
      events = Event.socials_dates(today).map{ |s| s[1] }.flatten
    else
      @date = get_date(params[:date])

      if @listing_dates.include?(@date)
        events =  Event.socials_on_date(@date)
      else
        flash[:warn] = 'We can only show you events for the next 14 days'
        logger.warn("Not a date in the visible range: #{@date}")
        redirect_to map_socials_path
        return
      end
    end

    if events.nil?
      empty_map
    else
      venues = events.map{ |e| e.venue }.uniq
      @map_options = { "zoom" => 14, "auto_zoom" => false } if venues.count == 1

      @json = venues.to_gmaps4rails do |venue, marker|

        venue_events =  if @date
                          [Event.socials_on_date(@date, venue), Event.cancelled_events_on_date(@date)]
                        else
                          Event.socials_dates(today, venue)
                        end

        marker.infowindow render_to_string(:partial => "socials_map_info", :locals => { venue: venue, events: venue_events })

        json_options =  { id: venue.id, title: venue.name}
        if venue.id.to_s == params[:venue_id]
          json_options.merge!coloured_marker_json_options(:green)
        end
        marker.json(json_options)
      end

      @highlighted_venue = Venue.find(params[:venue_id]) if params[:venue_id]
    end
  end

  private

  # TODO: get_day and get_date maybe don't belong here...

  class NonDayError < StandardError; end
  # Return a Capitalised string IF the input refers to a valid listing day
  def get_day(day_string)
    return unless day_string
    day = day_string.titlecase

    case day
    when "Today"      then Event.weekday_name(today)
    when "Tomorrow"   then Event.weekday_name(today + 1)
    when *DAYNAMES
      day
    else
      raise NonDayError.new("Not a recognised day: #{day}")
    end
  end

  # Return a Date IF the input refers to a valid listing date
  def get_date(date_string)
    return unless date_string
    case date_string
    when "today"      then today
    when "tomorrow"   then today + 1
    else
      date_string.to_date rescue nil
    end
  end

  def coloured_marker_json_options(colour)
    if [  :black,
          :grey,
          :white,
          :orange,
          :yellow,
          :purple,
          :green].include?(colour)
      { picture: "https://maps.google.com/mapfiles/marker_#{colour.to_s}.png",
        shadow_picture: 'https://maps.google.com/mapfiles/shadow50.png',
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
    @map_options =  { center_latitude: 51.5264,
                      center_longitude: -0.0878,
                      zoom: 11
                    }
  end
end

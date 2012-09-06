class MapsController < ApplicationController
  
  def map
    # Varnish will cache the page for 3600 seconds = 1 hour:
    response.headers['Cache-Control'] = 'public, max-age=3600'
    
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
    
    Venue.regular_venues.each do |venue|
    
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
    
    # TODO Duplicated from website controller:
    if (Date.local_today.midnight)  > Time.local_now.ago(4.hours)
      # Would be great to just use 4.hours.ago, but timezones would screw it up??
      @today = Date.local_yesterday
    else
      @today = Date.local_today
    end
    
    @classes = Event.class_listing
    
    render :layout => 'map'
  end
  
  def venue_map_info
    @venue = Venue.find(params[:id])
    render :layout => false
  end

end

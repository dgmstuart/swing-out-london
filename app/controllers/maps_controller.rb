class MapsController < ApplicationController
  
  def map
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
    
    Venue.active_venues.each do |venue|
    
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
        "[ERROR]: 'position' was nil when trying to plot a marker for venue id #{params[:id]}"
      end
    end
    
    render :layout => 'map'
  end
  
  def venue_map_info
    @venue = Venue.find(params[:id])
    render :layout => false
  end

end

module MapsHelper
  
  def map(controller_map_options, json)
    map_options = { max_zoom: 15,
                    raw:<<-END
                        {
                          zoomControl: true,
                          zoomControlOptions: {
                            style: google.maps.ZoomControlStyle.LARGE,
                            position: google.maps.ControlPosition.RIGHT_TOP
                          },
                          panControl:false,
                          overviewMapControl: true,
                          overviewMapControlOptions: {
                            opened:true
                          },
                        }
                        END
                  } 
    map_options.merge!(controller_map_options) if controller_map_options
    gmaps(
      map_options: map_options,
      markers: { "data" => json }
    )
  end

end
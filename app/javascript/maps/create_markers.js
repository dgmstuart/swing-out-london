export function createMarkers(map, venues) {
  if (!venues.length) { return true }

  var bounds = new google.maps.LatLngBounds();

  venues.forEach(createMarker)

  map.fitBounds(bounds);

  function createMarker(venue) {
    var position = new google.maps.LatLng(
      venue.position.lat,
      venue.position.lng
    )

    bounds.extend(position);

    var marker = new google.maps.Marker({
      position: position,
      title: venue.title,
      icon: venue.icon,
      map: map
    });

    var infoWindow = new google.maps.InfoWindow({
      content: venue.infoWindowContent
    });

    marker.addListener('click', function() {
      if (window.activeInfoWindow) { window.activeInfoWindow.close();}
      infoWindow.open(map, marker);
      window.activeInfoWindow = infoWindow;
    });

    window.markers.push(marker)
  }
}

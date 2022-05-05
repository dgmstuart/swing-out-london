function updateMap(updateControl, map) {
  var url = updateControl.dataset.url

  if (activeInfoWindow) { activeInfoWindow.close();}

  clearAllMarkers();
  createNewMarkers(url);

  return markers;

  function clearAllMarkers() {
    markers.forEach(clearMarker)
  }

  function clearMarker(marker) {
    marker.setMap(null);
  }

  function createNewMarkers(url) {
    fetch(url)
      .then(response => {
        return response.json()
      })
      .then(data => {
        createMarkers(map, data.markers)
      })
  }
}

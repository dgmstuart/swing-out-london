import { createMarkers } from './create_markers'

export function updateMap(updateControl, map) {
  var url = updateControl.dataset.url

  if (window.activeInfoWindow) { window.activeInfoWindow.close();}

  clearAllMarkers();
  createNewMarkers(url);

  return window.markers;

  function clearAllMarkers() {
    window.markers.forEach(clearMarker)
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

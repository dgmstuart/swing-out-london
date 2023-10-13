import { setupMap } from './setup_map'

function initMap() {
  var mapElement = document.getElementById('map');
  var venues = JSON.parse(mapElement.dataset.markers);
  const { center, zoom } = JSON.parse(mapElement.dataset.config);

  var mapControlOptions = {
    zoomControl: true,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.LARGE,
      position: google.maps.ControlPosition.RIGHT_TOP
    },
    fullscreenControl: false,
    mapTypeControl: false
  }

  var mapBasicOptions = {
    center: center,
    zoom: zoom,
    maxZoom: 19,
  }

  var mapOptions = Object.assign({},
    mapControlOptions,
    mapBasicOptions
  );

  var map = new google.maps.Map(mapElement, mapOptions);

  setupMap(map, venues);
}

window.initMap = initMap;

import { setupMap } from './setup_map'

function initMap() {
  var mapElement = document.getElementById('map');
  var venues = JSON.parse(mapElement.dataset.markers);

  var mapControlOptions = {
    zoomControl: true,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.LARGE,
      position: google.maps.ControlPosition.RIGHT_TOP
    },
    fullscreenControl: false,
    mapTypeControl: false
  }

  var barNightjar = {lat: 51.526532, lng: -0.087777}

  var mapBasicOptions = {
    center: barNightjar,
    zoom: 11,
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

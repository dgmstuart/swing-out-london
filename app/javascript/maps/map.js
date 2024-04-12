import { GoogleMapsApi } from './google_maps_api'

export class Map {
  constructor({ apiKey, config, initialMarkers, mapElement }) {
    this.apiKey = apiKey;
    this.config = config;
    this.initialMarkers = initialMarkers;
    this.mapElement = mapElement;

    const mapsApi = new GoogleMapsApi({ apiKey })
    if (mapsApi.isLoaded()) {
      this._initMap();
    } else {
      mapsApi.load(this._initMap.bind(this))
    }
  }

  #mapInstance = null
  #markers = []
  #activeInfoWindow = null

  updateMarkers(markersParams) {
    this._closeActiveWindow()
    this._clearAllMarkers()
    this._createMarkers(markersParams)
  }

  _createMarkers(markersParams) {
    if (!markersParams.length) { return true }

    var bounds = new google.maps.LatLngBounds();

    markersParams.forEach(({ lat, lng, ...others }) => {
      const position = new google.maps.LatLng(lat, lng)
      this._createMarker({ position, ...others } )
      bounds.extend(position)
    })

    this.#mapInstance.fitBounds(bounds);
  }

  _createMarker({ position, title, icon, content }) {
    const marker = new google.maps.Marker({
      position: position,
      title: title,
      icon: icon,
      map: this.#mapInstance
    });

    const infoWindow = new google.maps.InfoWindow({ content })

    marker.addListener('click', () => {
      this._closeActiveWindow()
      infoWindow.open(this.#mapInstance, marker);
      this.#activeInfoWindow = infoWindow;
    });

    this.#markers.push(marker)
  }

  _clearAllMarkers() {
    this.#markers.forEach(this._clearMarker)
  }

  _clearMarker(marker) {
    marker.setMap(null);
  }

  _closeActiveWindow() {
    if (this.#activeInfoWindow) { this.#activeInfoWindow.close() }
  }

  _initMap() {
    this.#mapInstance = this._createMap()
    this._createMarkers(this.initialMarkers)
  }

  _createMap() {
    return new window.google.maps.Map(this.mapElement, {
      center: this.config.center,
      zoom: this.config.zoom,
      maxZoom: 19,
      zoomControl: true,
      zoomControlOptions: {
        style: window.google.maps.ZoomControlStyle.LARGE,
        position: window.google.maps.ControlPosition.RIGHT_TOP
      },
      fullscreenControl: false,
      mapTypeControl: false
    });
  }
}

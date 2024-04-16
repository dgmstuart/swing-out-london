import { Loader } from "@googlemaps/js-api-loader"

export class Map {
  constructor({ apiKey, mapId, config, initialMarkers, boundsOffsetX, mapElement }) {
    this.apiKey = apiKey;
    this.mapId = mapId;
    this.config = config;
    this.boundsOffsetX = boundsOffsetX;
    this.mapElement = mapElement;

    const loader = new Loader({
      apiKey: apiKey,
      version: "weekly"
    });

    loader.load().then(async () => {
      this.#mapInstance = await this._createMap()

      const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
      this.AdvancedMarkerElement = AdvancedMarkerElement;
      this.PinElement = PinElement;
      this._createMarkers(initialMarkers)
    })
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

    const only = markersParams.length === 1

    markersParams.forEach(({ lat, lng, ...others }) => {
      const position = new google.maps.LatLng(lat, lng)
      this._createMarker({ position, only, ...others } )
      bounds.extend(position)
    })

    const padding = this._boundsPadding()
    this.#mapInstance.fitBounds(bounds, padding)
  }

  async _createMarker({ position, title, highlighted, only, content }) {
    const marker = new this.AdvancedMarkerElement({
      position: position,
      title: title,
      map: this.#mapInstance,
      ...(highlighted ? { content: this._highlightedPin() } : {})
    });

    const infoWindow = new google.maps.InfoWindow({ content })
    const infoWindowOpenArgs = { markerCoordinates: position, marker, infoWindow }

    marker.addListener('click', () =>
      this._openInfoWindow(infoWindowOpenArgs)
    );

    this.#markers.push(marker)

    if (only || highlighted) {
      this._openInfoWindow(infoWindowOpenArgs)
    }
  }

  _openInfoWindow({ markerCoordinates, marker, infoWindow }) {
    google.maps.event.addListener(infoWindow, 'visible', () => {
      this._ensureInfoWindowIsVisible({ markerCoordinates })
    })

    this._closeActiveWindow()
    infoWindow.open(this.#mapInstance, marker)
    this.#activeInfoWindow = infoWindow
  }

  _ensureInfoWindowIsVisible({ markerCoordinates }) {
    // Use the coordinates of the clicked marker as the reference point:
    var markerBounds = new google.maps.LatLngBounds(markerCoordinates)

    // ensure that the portion of the info window to the left of the marker (half the width) doesn't overlap the menu:
    const infoWindowElement = document.querySelector('.gm-style-iw-d')
    const infoWindowWidth = infoWindowElement.offsetWidth
    const padding = this._boundsPadding(infoWindowWidth / 2)

    // scroll the minimum amount to ensure that the info window is fully visible
    this.#mapInstance.panToBounds(markerBounds, padding)
  }

  _highlightedPin() {
    const pin =  new this.PinElement({
      background: "#fab64a",
      borderColor: "#d48101",
      glyphColor: "#d48101"
    })
    return pin.element
  }

  _boundsPadding(extraOffset = 0) {
    const padding = 45 // if we don't pass any padding, GoogleMaps sets 45px
    return {
      left:(padding + this.boundsOffsetX() + extraOffset),
      right:padding,
      top:padding,
      bottom:padding
    }
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

  async _createMap() {
    const { Map } = await google.maps.importLibrary("maps");

    return new Map(this.mapElement, {
      mapId: this.mapId,
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

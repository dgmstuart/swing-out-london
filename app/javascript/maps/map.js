import { Loader } from "@googlemaps/js-api-loader"

export class Map {
  constructor({ apiKey, mapId, config, initialMarkers, mapElement }) {
    this.apiKey = apiKey;
    this.mapId = mapId;
    this.config = config;
    this.mapElement = mapElement;

    const loader = new Loader({
      apiKey: apiKey,
      version: "weekly"
    });

    loader.load().then(async () => {
      const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
      this.AdvancedMarkerElement = AdvancedMarkerElement;
      this.PinElement = PinElement;
      this.#mapInstance = await this._createMap()
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

    markersParams.forEach(({ lat, lng, ...others }) => {
      const position = new google.maps.LatLng(lat, lng)
      this._createMarker({ position, ...others } )
      bounds.extend(position)
    })

    this.#mapInstance.fitBounds(bounds);
  }

  async _createMarker({ position, title, highlighted, content }) {
    const marker = new this.AdvancedMarkerElement({
      position: position,
      title: title,
      map: this.#mapInstance,
      ...(highlighted ? { content: this._highlightedPin() } : {})
    });

    const infoWindow = new google.maps.InfoWindow({ content })

    marker.addListener('click', () => {
      this._closeActiveWindow()
      infoWindow.open(this.#mapInstance, marker);
      this.#activeInfoWindow = infoWindow;
    });

    this.#markers.push(marker)
  }

  _highlightedPin() {
    const pin =  new this.PinElement({
      scale: 1.2,
      background: "#3D6399",
      borderColor: "#384f6e",
      glyphColor: "#ffffff"
    })
    return pin.element
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

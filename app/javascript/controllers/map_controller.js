import { Controller } from "@hotwired/stimulus"
import { createMarkers } from '../maps/create_markers'
import { updateMap } from '../maps/update_map'

// Connects to data-controller="map"
export default class extends Controller {
  static targets = [ "map", "updateControl" ]
  static values = {
    apiKey: String,
    config: Object,
    markers: Array
  }
  static classes = [ "selected" ]

  #mapInstance = null;

  connect() {
    if (window.google && window.google.maps) {
      // Google Maps API is already loaded and available
      this.initMap()
    } else {
      // Google Maps API needs to be loaded
      window.initMap = this._initMap.bind(this)
      this._loadGoogleMapsAPI()
    }
  }

  update(event) {
    this._setSelected(event.target)
    updateMap(event.target, this.#mapInstance)
  }

  _initMap() {
    this.#mapInstance = new window.google.maps.Map(this.mapTarget, this._mapOptions())
    createMarkers(this.#mapInstance, this.markersValue)
  }

  _loadGoogleMapsAPI() {
    const script = document.createElement('script')
    script.async = true
    script.defer = true
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initMap&loading=async`
    document.head.appendChild(script)
  }

  _mapOptions() {
    return {
      center: this.configValue.center,
      zoom: this.configValue.zoom,
      maxZoom: 19,

      zoomControl: true,
      zoomControlOptions: {
        style: window.google.maps.ZoomControlStyle.LARGE,
        position: window.google.maps.ControlPosition.RIGHT_TOP
      },
      fullscreenControl: false,
      mapTypeControl: false
    }
  }

  _setSelected(updateControl) {
    this.updateControlTargets.forEach((element) => {
      element.classList.remove(this.selectedClass)
    })
    updateControl.classList.add(this.selectedClass)
  }
}

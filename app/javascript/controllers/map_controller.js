import { Controller } from "@hotwired/stimulus"
import { Map } from '../maps/map'

// Connects to data-controller="map"
export default class extends Controller {
  static targets = [ "map", "updateControl" ]
  static values = {
    apiKey: String,
    config: Object,
    markers: Array
  }
  static classes = [ "selected" ]

  #map = null

  connect() {
    this.#map = new Map({
      apiKey: this.apiKeyValue,
      config: this.configValue,
      initialMarkers: this.markersValue.map(this._markerData),
      mapElement: this.mapTarget
    })
  }

  update(event) {
    this._setSelected(event.target)
    this._updateFromUrl({
      url: event.target.dataset.url,
      callback: this._updateWithVenues.bind(this)
    })
  }

  _setSelected(updateControl) {
    this.updateControlTargets.forEach((element) => {
      element.classList.remove(this.selectedClass)
    })
    updateControl.classList.add(this.selectedClass)
  }

  _updateWithVenues(venues) {
    const markersData = venues.map(this._markerData)
    this.#map.updateMarkers(markersData)
  }

  _updateFromUrl({url, callback}) {
    fetch(url)
      .then(response => {
        return response.json()
      })
      .then(data => {
        callback(data.markers)
      })
  }

  _markerData(venue) {
    return {
      lat: venue.position.lat,
      lng: venue.position.lng,
      title: venue.title,
      icon: venue.icon,
      content: venue.infoWindowContent
    }
  }
}

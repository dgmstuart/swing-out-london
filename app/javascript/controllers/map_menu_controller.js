import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-menu"
export default class extends Controller {
  static targets = [ "menu", "currentlyShown" ]
  static classes = [ "open" ]

  toggle(event) {
    this.menuTarget.classList.toggle(this.openClass)
  }

  choose(event) {
    this.menuTarget.classList.remove(this.openClass)
    this.currentlyShownTarget.textContent = event.target.text
  }
}

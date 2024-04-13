import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-menu"
export default class extends Controller {
  static targets = [ "menu", "currentlyShown", "updateControl" ]
  static classes = [ "open", "selected" ]

  connect() {
    const selected = this.updateControlTargets.find(el => el.classList.contains(this.selectedClass))
    if (selected) {
      this.currentlyShownTarget.textContent = selected.text
    }
  }

  toggle(event) {
    this.menuTarget.classList.toggle(this.openClass)
  }

  choose(event) {
    this._setSelected(event.target)
    this.menuTarget.classList.remove(this.openClass)
    this.currentlyShownTarget.textContent = event.target.text
  }

  _setSelected(updateControl) {
    this.updateControlTargets.forEach((element) => {
      element.classList.remove(this.selectedClass)
    })
    updateControl.classList.add(this.selectedClass)
  }
}

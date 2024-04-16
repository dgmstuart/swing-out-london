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

    this.closeListener = document.addEventListener('click', this.#closeIfOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeListener)
  }

  toggle() {
    this.menuTarget.classList.toggle(this.openClass)
  }

  choose(event) {
    this.#setSelected(event.target)
    this.#close()
    this.currentlyShownTarget.textContent = event.target.text
  }

  #setSelected(updateControl) {
    this.updateControlTargets.forEach((element) => {
      element.classList.remove(this.selectedClass)
    })
    updateControl.classList.add(this.selectedClass)
  }

  #closeIfOutside(event) {
    if (!this.element.contains(event.target) && this.#isOpen()) {
      this.#close()
    }
  }

  #close() {
    this.menuTarget.classList.remove(this.openClass)
  }

  #isOpen() {
    return this.menuTarget.classList.contains(this.openClass)
  }
}

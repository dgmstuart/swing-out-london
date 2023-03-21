import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="organiser-link"
export default class extends Controller {
  static targets = [ "source" ]

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.textContent.trim())
  }
}

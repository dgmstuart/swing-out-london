import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-frequency"
export default class extends Controller {
  static targets = [ "daySelect", "datesInput" ]
  static classes = [ "hidden" ]

  setWeekly() {
    this.daySelectTarget.classList.remove(this.hiddenClass);
    this.datesInputTarget.classList.add(this.hiddenClass);
    this.datesInputTarget.querySelectorAll('input').forEach(el => { el.value = "" })
  }

  setInfrequently() {
    this.daySelectTarget.classList.add(this.hiddenClass);
    this.datesInputTarget.classList.remove(this.hiddenClass);
    this.daySelectTarget.querySelectorAll('select').forEach(el => { el.selectedIndex = null })
  }
}

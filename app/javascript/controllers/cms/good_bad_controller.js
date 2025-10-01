import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="good-bad"
export default class extends Controller {
  static targets = [ "target" ]
  static classes = [ "good", "bad" ]
  static values = { good: String }

  toggle({ detail: { value } }) {
    const classList = this.targetTarget.classList

    if (value === this.goodValue){
      classList.remove(this.badClass);
      classList.add(this.goodClass);
    } else {
      classList.remove(this.goodClass);
      classList.add(this.badClass);
    }
  }
}

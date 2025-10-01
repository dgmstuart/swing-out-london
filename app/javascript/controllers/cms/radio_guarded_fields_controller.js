import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radio-guarded-fields"
export default class extends Controller {
  static targets = [ "formGroup" ]
  static classes = [ "hidden" ]

  toggle(event) {
    const selectedValue = event.target.value
    this.dispatch("selected", { detail: { value: selectedValue } })

    this.formGroupTargets.forEach(formGroup => {
      if (formGroup.dataset.formGroupFor === selectedValue){
        formGroup.classList.remove(this.hiddenClass);
      } else {
        formGroup.classList.add(this.hiddenClass);
        this._clearInputs(formGroup.querySelectorAll('input'));
      }
    })
  }

  _clearInputs(inputs) {
    inputs.forEach(el => { el.value = "" })
  }
}

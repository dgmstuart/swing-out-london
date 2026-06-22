import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox-guarded-field"
export default class extends Controller {
  static targets = [ "formGroup" ]
  static classes = [ "hidden" ]

  toggle(event) {
    const classList = this.formGroupTarget.classList;
    if (event.srcElement.checked){
      classList.remove(this.hiddenClass);
    } else {
      classList.add(this.hiddenClass);
      this._clearInputs(this._formGroupInputs())
    }
  }

  _clearInputs(inputs) {
    inputs.forEach(el => { el.value = "" })
  }

  _formGroupInputs() {
    return this.formGroupTarget.querySelectorAll('input')
  }
}

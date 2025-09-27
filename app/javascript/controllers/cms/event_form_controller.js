import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-form"
export default class extends Controller {
  static #socialDanceFields = [ "title", "socialOrganiser", "socialHasClass" ]
  static #weeklyClassFields = [ "classOrganiser", "classStyle", "courseLength" ]
  static #whenFields = [ "when", "frequency", "frequencyWeekly", "daySelect", "datesInput", "cancellationsInput" ]
  static targets = [ "socialDetails", "classDetails", ...this.#weeklyClassFields, ...this.#socialDanceFields, ...this.#whenFields ]
  static classes = [ "hidden" ]

  socialDance() {
    this.socialDetailsTarget.classList.remove(this.hiddenClass);
    this.classDetailsTarget.classList.add(this.hiddenClass);
    this.whenTarget.classList.remove(this.hiddenClass);
    this.frequencyTarget.classList.remove(this.hiddenClass);
    this.frequencyWeeklyTarget.checked = false;
    this.#resetWeeklyClassFields();
  }

  weeklyClass() {
    this.socialDetailsTarget.classList.add(this.hiddenClass);
    this.classDetailsTarget.classList.remove(this.hiddenClass);
    this.whenTarget.classList.remove(this.hiddenClass);
    this.setWeekly();
    this.frequencyWeeklyTarget.checked = true;
    this.frequencyTarget.classList.add(this.hiddenClass);
    this.#resetSocialDanceFields();
  }

  socialClass(event) {
    if (event.srcElement.checked){
      this.classDetailsTarget.classList.remove(this.hiddenClass);
    } else {
      this.classDetailsTarget.classList.add(this.hiddenClass);
    }
  }

  setWeekly() {
    this.daySelectTarget.classList.remove(this.hiddenClass);
    this.datesInputTarget.classList.add(this.hiddenClass);
    this.datesInputTarget.querySelectorAll('input').forEach(el => { el.value = "" })
    this.cancellationsInputTarget.classList.remove(this.hiddenClass);
  }

  setInfrequently() {
    this.daySelectTarget.classList.add(this.hiddenClass);
    this.datesInputTarget.classList.remove(this.hiddenClass);
    this.daySelectTarget.querySelectorAll('select').forEach(el => { el.selectedIndex = null })
    this.cancellationsInputTarget.classList.add(this.hiddenClass);
    this.cancellationsInputTarget.querySelectorAll('input').forEach(el => { el.value = "" })
  }

  #resetSocialDanceFields() {
    this.titleTarget.value = ""
    this.socialOrganiserTarget.value = ""
    this.socialHasClassTarget.checked = false
  }

  #resetWeeklyClassFields() {
    this.classOrganiserTarget.value = ""
    this.classStyleTarget.value = ""
    this.courseLengthTarget.value = ""
  }
}

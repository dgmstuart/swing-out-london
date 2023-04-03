import accessibleAutocomplete from 'accessible-autocomplete'

function safeEnhanceSelectElement(selector) {
  const element = document.querySelector(selector);
  if (element === null) return;
  accessibleAutocomplete.enhanceSelectElement({
    selectElement: element,
    defaultValue: '',
    preserveNullOptions: true,
    showAllValues: true
  })
}

function initEventSelects() {
  safeEnhanceSelectElement('#event_venue_id')
  safeEnhanceSelectElement('#event_class_organiser_id')
  safeEnhanceSelectElement('#event_social_organiser_id')
}

function initClassStyleRadio() {
  const formGroup = document.getElementById("class-style-selection")
  if (formGroup === null) return;
  const radios = formGroup.querySelectorAll("input[type=radio]");
  const otherSelection = document.getElementById("class_style_option_other");
  const classStyleGroup = document.getElementById(otherSelection.dataset['target']);
  const hiddenClass = 'hidden';

  Array.from(radios).map(radio => {
    radio.onchange = function() {
      if (radio.value === 'other' && radio.checked) {
        classStyleGroup.classList.remove(hiddenClass)
      } else {
        classStyleGroup.classList.add(hiddenClass)
        classStyleGroup.querySelector('input').value = ""
      }
    }
  })
}

window.addEventListener("DOMContentLoaded", (_event) => {
  initClassStyleRadio();
  initEventSelects();
})

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
import "./controllers"

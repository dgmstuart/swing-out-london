import accessibleAutocomplete from 'accessible-autocomplete'

accessibleAutocomplete.enhanceSelectElement({
  selectElement: document.querySelector('#event_venue_id'),
  defaultValue: '',
  preserveNullOptions: true,
  showAllValues: true
})
accessibleAutocomplete.enhanceSelectElement({
  selectElement: document.querySelector('#event_class_organiser_id'),
  defaultValue: '',
  preserveNullOptions: true,
  showAllValues: true
})
accessibleAutocomplete.enhanceSelectElement({
  selectElement: document.querySelector('#event_social_organiser_id'),
  defaultValue: '',
  preserveNullOptions: true,
  showAllValues: true
})

function initClassStyleRadio() {
  const radios = document.getElementById("class-style-selection").querySelectorAll("input[type=radio]");
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

window.addEventListener('load', (event) => {
  initClassStyleRadio();
})

import "./controllers"

import accessibleAutocomplete from 'accessible-autocomplete'

accessibleAutocomplete.enhanceSelectElement({
  selectElement: document.querySelector('#event_venue_id'),
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

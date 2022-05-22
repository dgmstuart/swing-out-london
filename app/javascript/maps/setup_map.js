import { createMarkers } from './create_markers'
import { updateMap } from './update_map'

export function setupMap(map, venues) {
  createMarkers(map, venues);

  var updateControls = document.getElementsByClassName('js-update-map')

  Array.from(updateControls).forEach(setupUpdateControl)

  function setupUpdateControl(updateControl) {
    updateControl.addEventListener('click', function(event) {
      event.preventDefault();
      removeSelected();
      updateControl.classList.add('selected');
      updateMap(updateControl, map, markers);
    });
  }

  function removeSelected() {
    var highlighted = Array.from(document.getElementsByClassName('js-update-map selected'))
    highlighted.forEach(function(element) {
      element.classList.remove('selected');
    })
  }
}

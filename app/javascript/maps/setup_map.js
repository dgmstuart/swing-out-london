import { createMarkers } from './create_markers'
import { updateMap } from './update_map'

export function setupMap(map, venues) {
  createMarkers(map, venues);

  const updateControls = document.getElementsByClassName('js-update-map')
  const listings = document.querySelector('.listings')

  Array.from(updateControls).forEach(setupUpdateControl)

  function setupUpdateControl(updateControl) {
    updateControl.addEventListener('click', function(event) {
      event.preventDefault();

      console.log(listings)
      if (listings.classList.contains('open')) {
        if (!updateControl.closest("li").classList.contains('selected')) {
          removeSelected();
          updateControl.closest("li").classList.add('selected');
          updateMap(updateControl, map, markers);
        }
        listings.classList.remove('open')
      } else {
        listings.classList.add('open')
      }
    });
  }

  function removeSelected() {
    var highlighted = Array.from(document.getElementsByClassName('selected'))
    highlighted.forEach(function(element) {
      element.classList.remove('selected');
    })
  }
}

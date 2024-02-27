import { format } from 'timeago.js'

export function initListings() {
  if (document.body.classList.contains('listings') && document.body.classList.contains('index')) {
    var timeago = document.querySelector('time.timeago')
    timeago.innerHTML = format(timeago.getAttribute('time'));
  }
};


import { format } from 'timeago.js'

export function initListings() {
  if (document.body.classList.contains('listings') && document.body.classList.contains('index')) {
    var timeago = document.querySelector('time.timeago')
    timeago.innerHTML = format(timeago.getAttribute('time'));
    add_facebook_share_click_handler();
  }
};

function add_facebook_share_click_handler() {
  var height, left, other_options, share_link, size_and_position, top, url, width;
  share_link = document.querySelector(".share_button.facebook");
  url = share_link.getAttribute('href');
  document.querySelector(".share_button.facebook").setAttribute('href', "javascript: void(0)");
  width = 548;
  height = 325;
  left = (screen.width / 2) - (width / 2);
  top = (screen.height / 2) - (height / 2);
  size_and_position = "width=" + width + ", height=" + height + ", top=" + top + ", left=" + left;
  other_options = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,copyhistory=0";
  return share_link.addEventListener("click", () => {
    return window.open(url, 'sharer', "" + size_and_position + other_options);
  });
};

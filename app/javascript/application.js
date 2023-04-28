import { initListings } from './application/listing'
import { initSieveList } from './lib/sieve'

require("@rails/ujs").start()

window.addEventListener("DOMContentLoaded", () => {
  initListings();
  initSieveList(".sieveInput", ".sieveList");
});

var cheet = require('cheet.js')

cheet('↑ ↑ ↓ ↓ ← → ← → b a', function () {
  window.open("https://www.youtube.com/embed/iEaSaIhYZXg?autoplay=1", "popupWindow", "width=560,height=315");
});

require('./application/listing')

require("@rails/ujs").start()

global.jQuery = require('jquery');
var $ = global.jQuery;
window.$ = $;

require('../../vendor/javascript/jquery.sieve')
$(document).ready(function() {
  $("ul.sieve").sieve({ itemSelector: "li" });
  $("table.events").sieve({
    itemSelector: "tr",
    searchTemplate: "<div style='text-align: center'><label>Filter: <input type='text'></label></div>"
  });
});

var cheet = require('cheet.js')

cheet('↑ ↑ ↓ ↓ ← → ← → b a', function () {
  window.open("https://www.youtube.com/embed/iEaSaIhYZXg?autoplay=1", "popupWindow", "width=560,height=315");
});

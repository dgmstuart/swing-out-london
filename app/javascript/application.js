require('./application/listing')

require("@rails/ujs").start()

global.jQuery = require('jquery');
var $ = global.jQuery;
window.$ = $;

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

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


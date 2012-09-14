$(document).ready ->
  # Insert a Google Analytics event on all Socials links
  $('#socials .datelist .social_details a').click ->
    _gaq.push(['_trackEvent', 'Social Link', '#'+ this.id, this.text]) 
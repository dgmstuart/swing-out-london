$(document).ready ->
  $("time.timeago").timeago()
  load_latest_tweet()
  add_socials_analytics_events()

load_latest_tweet = ->
  $.get "latest_tweet", (tweet)->
    $("#latest_tweet").html(tweet)

# Insert a Google Analytics event on all Socials links:   
add_socials_analytics_events = ->
  $('#socials .datelist .social_details a').click ->
    _gaq.push(['_trackEvent', 'Social Link', '#'+ this.id, this.text])
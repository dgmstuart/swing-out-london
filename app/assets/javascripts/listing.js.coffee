$(document).ready ->
  load_last_updated()
  load_latest_tweet()
  add_socials_analytics_events()

load_last_updated = ->
  $.get "last_updated", (last_updated_msg)->
    $("#last_updated_ago").html(last_updated_msg)

load_latest_tweet = ->
  $.get "latest_tweet", (tweet)->
    $("#latest_tweet").html(tweet)

# Insert a Google Analytics event on all Socials links:   
add_socials_analytics_events = ->
  $('#socials .datelist .social_details a').click ->
    _gaq.push(['_trackEvent', 'Social Link', '#'+ this.id, this.text])
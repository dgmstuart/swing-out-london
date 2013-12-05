$(document).ready ->
  if($('body').hasClass('website') && $('body').hasClass('index'))
    $("time.timeago").timeago()
    load_latest_tweet()
    add_socials_analytics_events()
    add_advertisement_analytics_events()

load_latest_tweet = ->
  $.get "latest_tweet", (tweet)->
    $("#latest_tweet").html(tweet)

# Insert a Google Analytics event on all Socials links:
add_socials_analytics_events = ->
  $('#socials .datelist .details a').click ->
    _gaq.push(['_trackEvent', 'Social Link', '#'+ this.id, this.text])

# Insert a Google Analytics event on advertisements:
add_advertisement_analytics_events = ->
  $('.ad_units a').click ->
    _gaq.push(['_trackEvent', 'Advert Link', this.id, this.href])


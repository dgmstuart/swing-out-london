$(document).ready ->
  if($('body').hasClass('website') && $('body').hasClass('index'))
    $("time.timeago").timeago()
    load_latest_tweet()
    add_socials_analytics_events()
    add_advertisement_analytics_events()
    add_donation_button_analytics_event()
    add_facebook_share_analytics_event()
    add_tweet_share_analytics_event()
    add_facebook_share_click_handler()

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

add_donation_button_analytics_event = ->
  $('.donate_button').click ->
    _gaq.push(['_trackEvent', 'Donate Button', 'donate_button', this.href])

add_facebook_share_analytics_event = ->
  $('.share_button.facebook').click ->
    alert("foo")
    _gaq.push(['_trackEvent', 'Share Button', 'facebook', this.href])

add_tweet_share_analytics_event = ->
  $('.share_button.twitter').click ->
    alert("bar")

    _gaq.push(['_trackEvent', 'Share Button', 'twitter', this.href])

add_facebook_share_click_handler = ->
  share_link = $(".share_button.facebook")
  url = share_link.attr('href')
  $(".share_button.facebook").attr('href', "javascript: void(0)")

  width = 548
  height = 325

  left = (screen.width/2)-(width/2);
  top = (screen.height/2)-(height/2);

  size_and_position = "width=#{width}, height=#{height}, top=#{top}, left=#{left}"
  other_options = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,copyhistory=0"

  share_link.click ->
    window.open(url, 'sharer', "#{size_and_position}#{other_options}");

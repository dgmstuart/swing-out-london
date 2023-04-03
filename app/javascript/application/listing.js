import { format } from 'timeago.js'

(function() {
  var add_advertisement_analytics_events, add_donation_button_analytics_event, add_facebook_share_analytics_event, add_facebook_share_click_handler, add_socials_analytics_events, add_tweet_share_analytics_event;

  var $ = require('jquery');

  $(document).ready(function() {
    if ($('body').hasClass('listings') && $('body').hasClass('index')) {
      var timeago = document.querySelector('time.timeago')
      timeago.innerHTML = format(timeago.getAttribute('time'));
      add_socials_analytics_events();
      add_advertisement_analytics_events();
      add_donation_button_analytics_event();
      add_facebook_share_analytics_event();
      add_tweet_share_analytics_event();
      return add_facebook_share_click_handler();
    }
  });

  add_socials_analytics_events = function() {
    return $('#social_dances .datelist .details a').click(function() {
      return _gaq.push(['_trackEvent', 'Social Link', '#' + this.id, this.text]);
    });
  };

  add_advertisement_analytics_events = function() {
    return $('#advert a').click(function() {
      return _gaq.push(['_trackEvent', 'Advert Link', this.id, this.href]);
    });
  };

  add_donation_button_analytics_event = function() {
    return $('.donate_button').click(function() {
      return _gaq.push(['_trackEvent', 'Donate Button', 'donate_button', this.href]);
    });
  };

  add_tweet_share_analytics_event = function() {
    return $('.share_button.twitter').click(function() {
      return _gaq.push(['_trackEvent', 'Share Button', 'twitter', this.href]);
    });
  };

  add_facebook_share_analytics_event = function() {
    return $('.share_button.facebook').click(function() {
      return _gaq.push(['_trackEvent', 'Share Button', 'facebook', this.href]);
    });
  };

  add_facebook_share_click_handler = function() {
    var height, left, other_options, share_link, size_and_position, top, url, width;
    share_link = $(".share_button.facebook");
    url = share_link.attr('href');
    $(".share_button.facebook").attr('href', "javascript: void(0)");
    width = 548;
    height = 325;
    left = (screen.width / 2) - (width / 2);
    top = (screen.height / 2) - (height / 2);
    size_and_position = "width=" + width + ", height=" + height + ", top=" + top + ", left=" + left;
    other_options = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,copyhistory=0";
    return share_link.click(function() {
      return window.open(url, 'sharer', "" + size_and_position + other_options);
    });
  };

}).call(this);

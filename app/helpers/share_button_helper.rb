# frozen_string_literal: true

module ShareButtonHelper
  def twitter_button
    twitter_url = "https://twitter.com/intent/tweet"

    tweet_text = "If you want to learn to swing dance, #{tc('site_name')} lists all the classes in #{tc('city')}:"
    via = tc("twitter_handle")

    query_parameters = [
      "url=#{tc('site_url')}",
      "text=#{tweet_text}",
      "via=#{via}"
    ].join("&")

    alt_text = "Share #{tc('site_name')} on Twitter"

    link_to "Tweet",
            "#{twitter_url}?#{query_parameters}",
            title: alt_text,
            alt: alt_text,
            target: "_blank",
            class: "share_button twitter", rel: "noopener"
  end

  def facebook_button
    facebook_url = "https://www.facebook.com/sharer/sharer.php"

    share_title = "#{tc('site_name')} - Lindy Hop Listings"
    share_summary =
      "#{tc('site_name')} is a listing of all the swing dance classes in #{tc('city')}, and all the places you can go to dance."

    query_parameters = [
      "s=100",
      "p[url]=#{tc('site_url')}",
      # p[images][0] = SOME IMAGE,
      "p[title]='#{share_title}'",
      "p[summary]='#{share_summary}'"
    ].join("&")

    alt_text = "Share #{tc('site_name')} on Facebook"

    link_to "Share",
            "#{facebook_url}?#{query_parameters}",
            title: alt_text,
            alt: alt_text,
            target: "_blank",
            class: "share_button facebook", rel: "noopener"
  end

  def donate_button
    alt_text = "Donate to help keep #{tc('site_name')} running"

    link_to "Donate",
            Rails.application.config.x.donate_link,
            title: alt_text,
            alt: alt_text,
            target: "_blank",
            class: "share_button donate_button", rel: "noopener"
  end
end

module CommonHelper
  
  def nav_link(name, *args)
    # Render the link...
    link_to_unless_current(name, *args) do 
      # ...but if the page was current, render a span instead
      content_tag :span, name, :class => "current"
    end 
  end
  
  def tweet_message(tweet)
    if tweet.nil?
      "Could not load latest tweet. Please visit the " + 
      link_to("Swing Out London Twitter feed", "http://www.twitter.com/swingoutlondon", :title => "Swing Out London on Twitter")
    else
      tweet
    end
  end
  
end

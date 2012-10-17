## Colophon

* The styling of the site was inspired by vintage playbills, magazine listings and event posters. 
  The primary font used is [Futura](http://en.wikipedia.org/wiki/Futura_\(typeface\) "Wikipedia - Futura")
  (falling back to Trebuchet MS on Windows) which was designed in 1927.  
  
* The [vintage wallpaper](http://zebiii.deviantart.com/art/Patterns-2-94330934 "Patterns.2 by ZeBii on DeviantArt")
  in the background is by [ZeBii on DeviantArt](http://zebiii.deviantart.com/) 
   
* This site was written on a Mac. These days I use [TextMate](http://macromates.com/) 
  and [Chrome](http://www.google.com/chrome "The Google Chrome web browser") for development. 
   
* [CodeStyle's Font Stack Builder](http://www.codestyle.org/servlets/FontStack")
  and [Identifont](http://www.identifont.com/similar.html") came in handy for picking fonts. 
   
* The site uses a custom-built Content Management System (CMS) 
  which I wrote from scratch in [Ruby on Rails](http://rubyonrails.org/) (Rails 3, Ruby 1.9). 
  I use [Git](http://git-scm.com/) for version control and there is
  a [public repo for Swing Out London on github](https://github.com/leveretweb/Swing-Out-London).
  The following resources were used:
    
    * [Haml](http://haml.info/), 
      [Markdown](http://daringfireball.net/projects/markdown)
      (via the [Redcarpet](https://github.com/vmg/redcarpet) gem),
      [Sass](http://sass-lang.com/) (.scss) and
      [CoffeeScript](http://coffeescript.org/)
      for writing the HTML, CSS and Javascript;
    
    * [RSpec](http://haml.info/),
      [Factory Girl](https://github.com/thoughtbot/factory_girl),
      [Spork](https://github.com/sporkrb/spork/)
      and [Guard](https://github.com/guard/guard)
      for testing;
    
    * [awesome_print](https://github.com/michaeldv/awesome_print),
      and [pry](http://pryrepl.org/) for debugging;
    
    * The [twitter](https://github.com/sferik/twitter) gem to retrieve the latest tweet;
    
    * [Google-Maps-for-Rails](https://github.com/apneadiving/Google-Maps-for-Rails/) for the maps.
  
* [RailsCasts](http://railscasts.com/) 
  and [Stack Overflow](http://stackoverflow.com/) are invaluable development resources.

* The site is currently hosted on [Heroku](http://heroku.com/), where the 
  [MemCachier](http://www.memcachier.com/)  add-on handles the caching.

* The site uses valid HTML5. The CSS is mostly valid, but some of the CSS3 doesn't validate at the moment.

* Performance monitoring is supplied by [NewRelic](http://newrelic.com/)
  and [Citrulu](http://www.citrulu.com/)  lets me know if anything breaks.
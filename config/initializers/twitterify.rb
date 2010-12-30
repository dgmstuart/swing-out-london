class String

  #Convert http, www. and @ into links
  def twitterify!
    self.gsub!(/\b((http:\/\/|www\.)([A-Za-z0-9\-_=%&@\?\.\/]+))\b/) {
      match = $1
      tail  = $3

      case match
        when /^www/ then  "<a href=\"http://#{match}\">#{match}</a>"   
        else              "<a href=\"#{match}\">#{match}</a>"
      end
    }
    
    # Match '@' tags (and exclude email address endings):
    # 1. Must either be at the beginning of the string (^) or begin with a non-alphanumeric or an underscore.
    # 2. Body after the '@' can only be alphanumeric or underscore.
    # 3. $1 matches the whole string (including any character before the @)
    #    $2 matches the character before the @
    #    $3 matches the @
    #    $4 matches what is hopefully the twitter username
    self.gsub!(/((^|[^A-Za-z0-9_])(@)([A-Za-z0-9_]+))/){ "<a href=\"http://twitter.com/#{$4}\">@#{$4}</a>" }
  end

  def twitterify
    self.dup.twitterify!
  end

end
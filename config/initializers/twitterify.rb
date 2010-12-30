class String

  #Convert http, www. and @ into links
  def twitterify!  
    changed = false
      
    self.gsub!(/\b((http:\/\/|www\.)([A-Za-z0-9\-_=%&@\?\.\/]+))\b/) {
      changed = true
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
    self.gsub!(/((^|[^A-Za-z0-9_])(@)([A-Za-z0-9_]+))/){ 
      changed=true
      "#{$2}<a href=\"http://twitter.com/#{$4}\">@#{$4}</a>" 
    }
    
    #The convention is for '!' methods to return nil if they haven't made changes
    if changed
      return self
    else
      return nil
    end
  end

  def twitterify
    result = self.dup.twitterify!
    
    if result.nil?
      return self
    else
      return result
    end
  end

end
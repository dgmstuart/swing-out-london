class APICache
  class DalliStore < APICache::AbstractStore

    def expired?(key, timeout)
      # If for some reason the created_at key gets unset, set it such that it times out:
      @dalli.set("#{key}_created_at", Time.now + timeout + 1 ) if @dalli.get("#{key}_created_at").nil?
      
      Time.now - @dalli.get("#{key}_created_at") > timeout
    end
  end
end
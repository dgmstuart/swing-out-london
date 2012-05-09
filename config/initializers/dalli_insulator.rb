def Cache.get(key)
  Configuration.dalliClient.get(key)    
rescue Dalli::RingError => e
  logger.error "[ERROR]: Dalli failed! '#{e}'"
end
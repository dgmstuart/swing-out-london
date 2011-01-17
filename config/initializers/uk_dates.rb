class String
   def to_date
     begin
       parsed_date = Date.parse(self)
     rescue Exception => msg
       logger.warn "[WARNING]: Bad date found: '#{self}' - ignored"
       return
     else
       # Switch around the day and the month
       return parsed_date
      end
   end
end
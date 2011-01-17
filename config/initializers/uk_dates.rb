class String
   def to_uk_date    
     #HACK - to get around stupid date parsing not recognising UK dates
     debugger
     
     begin
       parsed_date = Date.parse(self)
     rescue Exception => msg
       logger.warn "[WARNING]: Bad date found: '#{self}' - ignored"
       return
     else
       # Switch around the day and the month
       return Date.new(parsed_date.year, parsed_date.day, parsed_date.month)
      end
   end
end
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


class Date
  def self.local_today
    Time.zone.today.to_date
  end
    
  def self.local_tomorrow
    (Time.zone.now + 1.day).to_date
  end
end
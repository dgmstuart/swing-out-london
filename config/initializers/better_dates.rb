class Date
  def self.local_today
    Time.zone.today.to_date
  end
    
  def self.local_tomorrow
    # For some reason, Time.tomorrow doesn't seem to be implemented
    (Time.zone.now + 1.day).to_date
  end
  
  def self.local_yesterday
    (Time.zone.now - 1.day).to_date
  end
end

class Time
  def self.local_now
    Time.zone.now
  end
end
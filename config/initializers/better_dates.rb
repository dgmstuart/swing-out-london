# frozen_string_literal: true

class Date
  def self.local_today
    Time.zone.today.to_date
  end

  def self.local_tomorrow
    # For some reason, Time.tomorrow doesn't seem to be implemented
    1.day.from_now.to_date
  end

  def self.local_yesterday
    1.day.ago.to_date
  end
end

class Time
  def self.local_now
    Time.zone.now
  end
end

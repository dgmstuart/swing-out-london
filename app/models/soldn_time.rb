# frozen_string_literal: true

class SOLDNTime
  MAX_LISTING_DATES = 14

  class << self
    def today
      # Use local clock time: four elapsed hours can cross a daylight-saving change.
      if Time.zone.now.hour < 4
        Date.current.yesterday
      else
        Date.current
      end
    end

    def listing_dates(first_date = today, number_of_days: MAX_LISTING_DATES)
      (first_date..).first(number_of_days)
    end
  end
end

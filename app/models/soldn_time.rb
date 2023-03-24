# frozen_string_literal: true

class SOLDNTime
  class << self
    def today
      if Date.current.midnight > 4.hours.ago
        Date.current.yesterday
      else
        Date.current
      end
    end
  end
end

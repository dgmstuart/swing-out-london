# frozen_string_literal: true

# Class for calculating if an event will be listed or not
class EventStatus
  def status_for(event)
    return :listed if event.latest_date == Date.current

    if event.future_dates?
      :listed
    else
      :not_listed
    end
  end
end

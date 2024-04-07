# frozen_string_literal: true

# "Archives" {Event}s by setting a {last_date}.
#
# Tries to make a reasonable guess of the actual last date, or uses the
# earliest possible Ruby date as way to say "unknown" but definitely ended at
# some point.
class EventArchiver
  THE_BEGINNING_OF_TIME = Date.new

  def archive(event)
    return true if event.ended? # if it's already ended, there's nothing to do

    event.update(last_date: most_recent_date(event))
  end

  private

  def most_recent_date(event)
    if event.weekly?
      Date.current.prev_occurring(event.day.downcase.to_sym)
    else
      event.latest_date || THE_BEGINNING_OF_TIME
    end
  end
end

# frozen_string_literal: true

# Presenter for displaying whether an event is currently listed or not, and why
class EventStatusDescription
  def initialize(event)
    @event = event
  end

  def description
    case status
    in :listed
      "Will be listed until #{I18n.l(event.latest_date, format: :default)}"
    in :not_listed
      "Not listed (no future dates)"
    end
  end

  def css_class
    case status
    in :listed
      "notice"
    in :not_listed
      "alert"
    end
  end

  private

  attr_reader :event

  def status
    return :listed if event.latest_date == Date.current

    if event.future_dates?
      :listed
    else
      :not_listed
    end
  end
end

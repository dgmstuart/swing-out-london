# frozen_string_literal: true

# Presenter for displaying whether an event is currently listed or not, and why
class EventStatusDescription
  def initialize(event, status_calculator: EventStatus.new)
    @event = event
    @status_calculator = status_calculator
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

  attr_reader :event, :status_calculator

  def status
    status_calculator.status_for(event)
  end
end

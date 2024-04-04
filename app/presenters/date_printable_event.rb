# frozen_string_literal: true

# Wraps an {Event} with methods for formatting the lists of scheduled and
# cancelled dates
class DatePrintableEvent
  def initialize(event, date_printer = DatePrinter.new)
    @event = event
    @date_printer = date_printer
  end

  def print_dates
    date_printer.print(event.dates)
  end

  def print_cancellations
    date_printer.print(event.cancellations)
  end

  private

  attr_reader :event, :date_printer
end

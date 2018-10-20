# frozen_string_literal: true

class ImportedDates
  def initialize(imported_event)
    @imported_event = imported_event
  end

  def name
    @imported_event.name
  end

  def dates_to_import
    dates = @imported_event.dates_to_import.map { |d| Date.parse(d) }
    dates.map { |d| d.strftime('%A %-d %b %Y') }.join(', ')
  end
end

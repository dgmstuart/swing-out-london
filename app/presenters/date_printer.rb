# frozen_string_literal: true

# Prints out dates in a list
class DatePrinter
  def initialize(separator: ",", format: :default)
    @separator = separator
    @format = format
  end

  def print(dates)
    dates.collect { |d| I18n.l(d, format:) }.join(separator)
  end

  private

  attr_reader :event, :format, :separator
end

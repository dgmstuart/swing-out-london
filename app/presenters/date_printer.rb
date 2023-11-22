# frozen_string_literal: true

class DatePrinter
  def initialize(separator: ",", format: :uk_date)
    @separator = separator
    @format = format
  end

  def print(dates)
    dates.collect { |d| d.to_fs(format) }.join(separator)
  end

  private

  attr_reader :event, :format, :separator
end

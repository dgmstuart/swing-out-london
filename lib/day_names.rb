# frozen_string_literal: true

module DayNames
  class NonDayError < StandardError; end

  def self.name(date)
    I18n.l(date, format: "%A")
  end

  def self.same_weekday?(day_name, date)
    day_name == name(date)
  end
end

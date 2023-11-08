# frozen_string_literal: true

class DatesStringValidator < ActiveModel::EachValidator
  SOLDN_START_DATE = Date.parse("2010-08-16")

  def validate_each(record, attribute, value)
    return if value.blank?

    date_strings = value.split(",").map(&:strip)
    problems = problem_date_strings(date_strings)

    errors = ErrorAdder.new(record, attribute)
    errors.add("contained some invalid dates", problems[:invalid]) if problems[:invalid].any?
    errors.add("contained some dates in the past", problems[:past]) if problems[:past].any?
    errors.add("contained some dates unreasonably far in the future", problems[:too_far_future]) if problems[:too_far_future].any?
  end

  private

  class ErrorAdder
    def initialize(record, attribute)
      @record = record
      @attribute = attribute
    end

    def add(description, problem_dates)
      message = "#{description}: #{problem_dates.join(', ')}"
      @record.errors.add(@attribute, message)
    end
  end

  def problem_date_strings(date_strings)
    parser = DateStringParser.new
    date_strings.each_with_object({ invalid: [], past: [], too_far_future: [] }) do |date_string, problems|
      date = parser.parse(date_string)
      if date
        problems[:past] << date_string if date < past_cutoff
        problems[:too_far_future] << date_string if date > 2.years.from_now
      else
        problems[:invalid] << %("#{date_string}")
      end
    end
  end

  def past_cutoff
    if options[:allow_past]
      SOLDN_START_DATE
    else
      Date.current
    end
  end
end

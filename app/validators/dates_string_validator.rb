# frozen_string_literal: true

require "date_string_parser"

class DatesStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    date_strings = value.split(",").map(&:strip)
    problems = problem_date_strings(date_strings)

    problems.each do |type, problem_dates|
      description = {
        invalid: "contained some invalid dates",
        past: "contained some dates in the past",
        distant_past: "contained some dates in the distant past",
        distant_future: "contained some dates unreasonably far in the future"
      }.fetch(type)
      message = "#{description}: #{problem_dates.join(', ')}"

      record.errors.add(attribute, message)
    end
  end

  private

  def problem_date_strings(date_strings)
    parser = DateStringParser.new
    date_strings.each_with_object(new_hash_of_arrays) do |date_string, problems|
      date = parser.parse(date_string)
      if date
        form = DateForm.new(date, allow_past: options[:allow_past])
        form.errors.each { |error| problems[error.type] << date_string } if form.invalid?
      else
        problems[:invalid] << %("#{date_string}")
      end
    end
  end

  def new_hash_of_arrays
    Hash.new { |hash, key| hash[key] = [] }
  end

  class DateForm
    include ActiveModel::Validations

    def initialize(date, allow_past:)
      @date = date
      @allow_past = allow_past
    end

    attr_reader :date

    validates :date, past_date: true, if: -> { !allow_past }
    validates :date, distant_past_date: true, if: -> { allow_past }
    validates :date, distant_future_date: true

    private

    attr_reader :allow_past
  end
end

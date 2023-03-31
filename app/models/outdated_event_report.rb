# frozen_string_literal: true

class OutdatedEventReport
  attr_reader :out_of_date_events

  def initialize
    @out_of_date_events = Event.out_of_date.sort_by(&:expected_date)
  end

  def summary
    subject = out_of_date_message(@out_of_date_events.count) unless @out_of_date_events.empty?
    subject
  end

  def all_in_date?
    @out_of_date_events.empty?
  end

  private

  def out_of_date_message(count)
    "#{count} #{'event'.pluralize(count)} out of date"
  end
end

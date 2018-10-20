# frozen_string_literal: true

class OutdatedEventReport
  attr_reader :out_of_date_events, :near_out_of_date_events

  def initialize
    @out_of_date_events       = Event.out_of_date.sort_by(&:expected_date)
    @near_out_of_date_events  = Event.near_out_of_date.sort_by(&:title)
  end

  def summary
    subject = "#{@out_of_date_events.count} #{'event'.pluralize(@out_of_date_events.count)} out of date" unless @out_of_date_events.empty?
    subject += ", #{@near_out_of_date_events.count} #{'event'.pluralize(@near_out_of_date_events.count)} nearly out of date" unless @near_out_of_date_events.empty?
    subject
  end

  def all_in_date?
    @out_of_date_events.empty? && @near_out_of_date_events.empty?
  end
end

# frozen_string_literal: true

# Responsible for creating an {Event} and the {EventInstance}s associated with
# its dates
class EventCreator
  def initialize(repository = Event)
    @repository = repository
  end

  def create!(attrs)
    event_instances = event_instances(attrs.delete(:dates), attrs.delete(:cancellations), attrs[:frequency])
    attrs.merge!(event_instances:) unless event_instances.nil?
    repository.create!(attrs)
  end

  private

  attr_reader :repository

  def event_instances(dates, cancellations, frequency)
    return nil if dates.nil? && cancellations.nil?

    case frequency
    in 0
      build_occasional_instances(dates, cancellations)
    in 1
      build_weekly_instances(cancellations)
    end
  end

  def build_occasional_instances(dates, cancellations)
    Array(dates).map do |date|
      cancelled = Array(cancellations).include?(date)
      EventInstance.new(date:, cancelled:)
    end
  end

  def build_weekly_instances(cancellations)
    Array(cancellations).map do |date|
      EventInstance.new(date:, cancelled: true)
    end
  end
end

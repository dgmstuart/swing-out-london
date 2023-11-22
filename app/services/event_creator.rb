# frozen_string_literal: true

class EventCreator
  def initialize(repository = Event, attr_adaptor: EventDatesAttrs.new)
    @repository = repository
    @attr_adaptor = attr_adaptor
  end

  def create!(attrs)
    event_instances = event_instances(attrs[:dates], attrs[:cancellations], attrs[:frequency])
    attrs.merge!(event_instances:) unless event_instances.nil?
    attrs_with_dates = attr_adaptor.transform(attrs)
    repository.create!(attrs_with_dates)
  end

  private

  attr_reader :repository, :attr_adaptor

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

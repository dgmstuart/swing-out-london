# frozen_string_literal: true

class EventCreator
  def initialize(repository = Event, attr_adaptor: EventDatesAttrs.new)
    @repository = repository
    @attr_adaptor = attr_adaptor
  end

  def create!(attrs)
    attrs.merge!(event_instances: event_instances(attrs[:dates])) if attrs[:dates]
    attrs_with_dates = attr_adaptor.transform(attrs)
    repository.create!(attrs_with_dates)
  end

  private

  attr_reader :repository, :attr_adaptor

  def event_instances(dates)
    dates.map { |date| EventInstance.new(date:) }
  end
end

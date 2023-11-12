# frozen_string_literal: true

class EventCreator
  def initialize(repository = Event, attr_adaptor: EventDatesAttrs.new)
    @repository = repository
    @attr_adaptor = attr_adaptor
  end

  def create!(attrs)
    attrs_with_dates = attr_adaptor.transform(attrs)
    repository.create!(attrs_with_dates)
  end

  private

  attr_reader :repository, :attr_adaptor
end

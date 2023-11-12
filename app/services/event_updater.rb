# frozen_string_literal: true

class EventUpdater
  def initialize(record, attr_adaptor: EventDatesAttrs.new)
    @record = record
    @attr_adaptor = attr_adaptor
  end

  def update!(attrs)
    attrs_with_dates = attr_adaptor.transform(attrs)
    record.update!(attrs)
    record.reload
  end

  private

  attr_reader :record, :attr_adaptor
end

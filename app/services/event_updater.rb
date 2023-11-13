# frozen_string_literal: true

class EventUpdater
  def initialize(record, attr_adaptor: EventDatesAttrs.new, audit_commenter: EventParamsCommenter.new)
    @record = record
    @attr_adaptor = attr_adaptor
    @audit_commenter = audit_commenter
  end

  def update!(attrs)
    audit_comment = audit_commenter.comment(record, attrs)
    attrs.merge!(event_instances: event_instances(attrs[:dates])) if attrs[:dates]
    attrs_with_dates = attr_adaptor.transform(attrs)
    record.update!(attrs_with_dates.merge(audit_comment))
    record.reload
  end

  private

  attr_reader :record, :attr_adaptor, :audit_commenter

  def event_instances(dates)
    dates.map { |date| EventInstance.find_or_initialize_by(event_id: record.id, date:) }
  end
end

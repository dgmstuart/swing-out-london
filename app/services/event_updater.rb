# frozen_string_literal: true

class EventUpdater
  def initialize(record, attr_adaptor: EventDatesAttrs.new, audit_commenter: EventParamsCommenter.new)
    @record = record
    @attr_adaptor = attr_adaptor
    @audit_commenter = audit_commenter
  end

  def update!(attrs)
    audit_comment = audit_commenter.comment(record, attrs)
    attrs_with_dates = attr_adaptor.transform(attrs)
    record.update!(attrs_with_dates.merge(audit_comment))
    record.reload
  end

  private

  attr_reader :record, :attr_adaptor, :audit_commenter
end

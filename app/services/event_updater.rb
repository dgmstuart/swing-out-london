# frozen_string_literal: true

class EventUpdater
  def initialize(record, attr_adaptor: EventDatesAttrs.new, audit_commenter: EventParamsCommenter.new)
    @record = record
    @attr_adaptor = attr_adaptor
    @audit_commenter = audit_commenter
  end

  def update!(attrs)
    audit_comment = audit_commenter.comment(record, attrs)
    event_instances = event_instances(attrs[:dates], attrs[:cancellations], attrs[:frequency])
    attrs.merge!(event_instances:) unless event_instances.nil?
    attrs_with_dates = attr_adaptor.transform(attrs)

    record.update!(attrs_with_dates.merge(audit_comment))
    record.event_instances.each(&:save!) unless event_instances.nil?
    record.reload
  end

  private

  attr_reader :record, :attr_adaptor, :audit_commenter

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
      EventInstance.find_or_initialize_by(event_id: record.id, date:).tap do |instance|
        instance.cancelled = Array(cancellations).include?(date)
      end
    end
  end

  def build_weekly_instances(cancellations)
    Array(cancellations).map do |date|
      EventInstance.find_or_initialize_by(event_id: record.id, date:, cancelled: true)
    end
  end
end

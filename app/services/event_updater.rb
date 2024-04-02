# frozen_string_literal: true

# Responsible for updating an {Event} and its associated {EventInstance}s
class EventUpdater
  def initialize(record, audit_commenter: EventParamsCommenter.new)
    @record = record
    @audit_commenter = audit_commenter
  end

  def update!(attrs)
    attrs.merge!(audit_commenter.comment(record, attrs))
    event_instances = event_instances(attrs)
    attrs.merge!(event_instances:) unless event_instances.nil?

    record.update!(attrs)
    record.event_instances.each(&:save!) unless event_instances.nil?
    record.reload
  end

  private

  attr_reader :record, :audit_commenter

  def event_instances(attrs)
    dates = attrs.delete(:dates)
    cancellations = attrs.delete(:cancellations)
    frequency = attrs[:frequency]
    return nil if dates.nil? && cancellations.nil?

    case frequency || record.frequency
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

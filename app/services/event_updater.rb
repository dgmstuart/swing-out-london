# frozen_string_literal: true

# Responsible for updating an {Event} and its associated {EventInstance}s
class EventUpdater
  def initialize(record, audit_commenter: EventParamsCommenter.new)
    @record = record
    @audit_commenter = audit_commenter
  end

  def update!(attrs)
    attrs.merge!(audit_commenter.comment(record, attrs))

    instances_attrs = extract_instances_attrs(attrs)
    persist_updates!(event_attrs: attrs, instances_attrs:)
    record.reload
  end

  private

  attr_reader :record, :audit_commenter

  def persist_updates!(event_attrs:, instances_attrs:)
    record.transaction do
      unless instances_attrs.nil?
        delete_instances!(instances_attrs)
        upsert_instances!(instances_attrs)
      end
      record.update!(event_attrs)
    end
  end

  def delete_instances!(instances_attrs)
    dates = instances_attrs.map { |attrs| attrs.fetch(:date) }
    record.event_instances.where.not(date: dates).destroy_all
  end

  def upsert_instances!(instances_attrs)
    instances_attrs.each do |instance_attrs|
      upsert_instance!(instance_attrs)
    end
  end

  def upsert_instance!(attrs)
    instance = record.event_instances.find_or_initialize_by(attrs.slice(:date))
    instance.assign_attributes(attrs)
    instance.save!
  end

  def extract_instances_attrs(attrs)
    dates = attrs.delete(:dates)
    cancellations = attrs.delete(:cancellations)
    return nil if dates.nil? && cancellations.nil?

    case attrs.fetch(:frequency, record.frequency)
    in 0
      occasional_instances_attrs(dates, cancellations)
    in 1
      weekly_instances_attrs(cancellations)
    end
  end

  def occasional_instances_attrs(dates, cancellations)
    Array(dates).map do |date|
      { date:, cancelled: Array(cancellations).include?(date) }
    end
  end

  def weekly_instances_attrs(cancellations)
    Array(cancellations).map do |date|
      { date:, cancelled: true }
    end
  end
end

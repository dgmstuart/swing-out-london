# frozen_string_literal: true

class AuditLogEntry
  def initialize(audit, time_formatter: ->(time) { I18n.l(time) })
    @audit = audit
    @time_formatter = time_formatter
  end

  class << self
    def all
      Audit.order(created_at: :desc).includes(:auditable).map { new(_1) }
    end
  end

  def created_at = audit.created_at
  def username = audit.username
  def action = audit.action
  def auditable_type = audit.auditable_type
  def auditable_id = audit.auditable_id
  def audited_changes = audit.audited_changes
  def comment = audit.comment

  def as_json
    {
      edited_by: audit.editor_name,
      created_at: time_formatter.call(audit.created_at),
      action:,
      record: "#{audit.auditable_type}(#{audit.auditable_id})",
      changes: audited_changes,
      comment:
    }
  end

  def auditable_name
    case auditable_type
    in "Event"
      auditable_event_name(record)
    in "Organiser"
      "Organiser: \"#{record.name}\""
    in "Venue"
      "Venue: \"#{record.name}\""
    end
  end

  private

  attr_reader :audit, :time_formatter

  def record
    audit.auditable || deleted_record
  end

  def deleted_record
    case auditable_type
    in "Event"
      DeletedEvent.new
    in "Organiser"
      DeletedOrganiser.new
    in "Venue"
      DeletedVenue.new
    end
  end

  def auditable_event_name(event)
    if event.has_class? && !event.has_social?
      "Class"
    else
      "Event: \"#{event.title}\""
    end
  end

  class DeletedEvent
    def has_class? = false # rubocop:disable Naming/PredicateName
    def has_social? = false # rubocop:disable Naming/PredicateName
    def title = nil
  end

  class DeletedVenue
    def name = nil
  end

  class DeletedOrganiser
    def name = nil
  end
end

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
  def auditable_type = audit.auditable_type
  def auditable_id = audit.auditable_id
  def audited_changes = audit.audited_changes
  def comment = audit.comment

  def action
    return "delete" if audit.action == "destroy"

    audit.action
  end

  def auditable_name
    return auditable_type if audit.action == "destroy"

    auditable.name
  end

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

  private

  attr_reader :audit, :time_formatter

  def auditable
    return DeletedRecord.new(type: auditable_type) if record.nil?

    case auditable_type
    in "Event"
      AuditableEvent.new(record)
    in "Organiser" | "Venue"
      AuditableRecord.new(record:, type: auditable_type)
    end
  end

  def record
    audit.auditable
  end

  class AuditableEvent
    def initialize(event)
      @event = event
    end

    def name
      if @event.has_class? && !@event.has_social?
        "Class"
      else
        "Event: \"#{@event.title}\""
      end
    end
  end

  class AuditableRecord
    def initialize(record:, type:)
      @record = record
      @type = type
    end

    def name
      "#{@type}: \"#{@record.name}\""
    end
  end

  class DeletedRecord
    def initialize(type:)
      @type = type
    end

    def name
      "#{@type} [DELETED]"
    end
  end
end

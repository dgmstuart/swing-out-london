# frozen_string_literal: true

# Presenter for exposing {Audit}s as entries in an audit log.
class AuditLogEntry
  def initialize(audit, time_formatter: ->(time) { I18n.l(time) }, url_helpers: UrlHelpers.new)
    @audit = audit
    @time_formatter = time_formatter
    @url_helpers = url_helpers
  end

  class << self
    def all
      Audit.order(created_at: :desc).includes(:auditable).map { new(_1) }
    end
  end

  def created_at = audit.created_at
  def username = audit.username
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

  def auditable_url
    case auditable_type
    in "Event"
      url_helpers.event_url(auditable_id)
    in "Venue"
      url_helpers.venue_url(auditable_id)
    in "Organiser"
      url_helpers.organiser_url(auditable_id)
    end
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

  attr_reader :audit, :time_formatter, :url_helpers

  def auditable_type = audit.auditable_type

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

  # @private
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

  # @private
  class AuditableRecord
    def initialize(record:, type:)
      @record = record
      @type = type
    end

    def name
      "#{@type}: \"#{@record.name}\""
    end
  end

  # @private
  class DeletedRecord
    def initialize(type:)
      @type = type
    end

    def name
      "#{@type} [DELETED]"
    end
  end
end

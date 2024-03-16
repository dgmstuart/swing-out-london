# frozen_string_literal: true

class AuditLogEntry
  def initialize(audit, time_formatter: ->(time) { I18n.l(time) })
    @audit = audit
    @time_formatter = time_formatter
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

  private

  attr_reader :audit, :time_formatter
end

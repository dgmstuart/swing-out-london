# frozen_string_literal: true

class Audit < ApplicationRecord
  def as_json
    {
      created_at: created_at,
      edited_by: editor.name,
      action: action,
      record: "#{auditable_type}(#{auditable_id})",
      changes: audited_changes,
      comment: comment
    }
  end

  def editor
    Editor.build(self)
  end
end

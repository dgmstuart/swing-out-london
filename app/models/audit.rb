# frozen_string_literal: true

class Audit < ApplicationRecord
  class << self
    def last_updated_at
      last&.created_at
    end
  end

  def as_json
    {
      edited_by: editor.name,
      created_at: created_at.to_fs,
      action:,
      record: "#{auditable_type}(#{auditable_id})",
      changes: audited_changes,
      comment:
    }
  end

  def editor
    Editor.build(self)
  end
end

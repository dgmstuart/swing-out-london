# frozen_string_literal: true

class Audit < ApplicationRecord
  belongs_to :auditable, polymorphic: true

  class << self
    def last_updated_at
      last&.created_at
    end
  end

  def editor_name
    editor.name
  end

  def editor
    Editor.build(self)
  end
end

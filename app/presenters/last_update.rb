# frozen_string_literal: true

class LastUpdate
  def initialize(resource, editor_builder: Editor)
    @resource = resource
    @editor_builder = editor_builder
  end

  delegate :name, :auth_id, to: :editor

  def time_in_words
    updated_at.to_s(:human_timestamp)
  end

  private

  attr_reader :resource, :editor_builder

  def editor
    editor_builder.build(last_audit)
  end

  def updated_at
    resource.updated_at
  end

  def last_audit
    resource.audits.last
  end
end

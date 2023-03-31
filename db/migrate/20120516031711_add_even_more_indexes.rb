# frozen_string_literal: true

class AddEvenMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index "events", %w[last_date frequency has_class]
    add_index "events", %w[event_type title]
  end

  def self.down
    remove_index "events", %w[last_date frequency has_class]
    remove_index "events", %w[event_type title]
  end
end

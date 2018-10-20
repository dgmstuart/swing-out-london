# frozen_string_literal: true

class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index 'events', %w[frequency day has_class]
    add_index 'events', %w[frequency day has_social]
  end

  def self.down
    remove_index 'events', %w[frequency day has_class]
    remove_index 'events', %w[frequency day has_social]
  end
end

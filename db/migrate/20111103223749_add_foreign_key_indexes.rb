# frozen_string_literal: true

class AddForeignKeyIndexes < ActiveRecord::Migration
  def self.up
    add_index :events, :venue_id
    add_index :events, :organiser_id
    add_index :events, :event_type
  end

  def self.down
    remove_index :events, :venue_id
    remove_index :events, :organiser_id
    remove_index :events, :event_type
  end
end

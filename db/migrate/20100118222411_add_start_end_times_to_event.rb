# frozen_string_literal: true

class AddStartEndTimesToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :start_hours, :integer
    add_column :events, :start_minutes, :integer
    add_column :events, :end_hours, :integer
    add_column :events, :end_minutes, :integer
  end

  def self.down
    remove_column :events, :end_minutes
    remove_column :events, :end_hours
    remove_column :events, :start_minutes
    remove_column :events, :start_hours
  end
end

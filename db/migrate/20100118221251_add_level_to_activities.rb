# frozen_string_literal: true

class AddLevelToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :level, :integer
  end

  def self.down
    remove_column :activities, :level
  end
end

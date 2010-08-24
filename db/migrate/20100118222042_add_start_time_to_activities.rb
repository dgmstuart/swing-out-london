class AddStartTimeToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :start_hours, :integer
    add_column :activities, :start_minutes, :integer
  end

  def self.down
    remove_column :activities, :start_minutes
    remove_column :activities, :start_hours
  end
end

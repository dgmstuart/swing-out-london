# frozen_string_literal: true

class AddEventIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :event_id, :string
  end

  def self.down
    remove_column :activities, :event_id
  end
end

class AddIndexesForEventsController < ActiveRecord::Migration
  def self.up
    add_index "events", ["last_date", "event_type"]
  end

  def self.down
    remove_index "events", ["last_date", "event_type"]
  end
end

class AddEvenMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index "events", ["last_date", "frequency", "has_class"]
    add_index "events", ["event_type", "title"]
  end

  def self.down
    remove_index "events", ["last_date", "frequency", "has_class"]
    remove_index "events", ["event_type", "title"]
  end
end

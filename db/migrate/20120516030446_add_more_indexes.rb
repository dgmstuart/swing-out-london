class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index "events", ["frequency", "day", "has_class"]
    add_index "events", ["frequency", "day", "has_social"]
  end

  def self.down
    remove_index "events", ["frequency", "day", "has_class"]
    remove_index "events", ["frequency", "day", "has_social"]
  end
end

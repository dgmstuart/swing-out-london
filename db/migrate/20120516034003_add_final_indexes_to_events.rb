class AddFinalIndexesToEvents < ActiveRecord::Migration
  def self.up
    add_index "events", ["frequency", "has_class"]
  end

  def self.down
    remove_index "events", ["frequency", "has_class"]
  end
end

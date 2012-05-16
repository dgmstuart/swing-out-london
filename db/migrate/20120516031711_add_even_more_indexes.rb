class AddEvenMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index "events", ["last_date", "frequency", "has_class"]
  end

  def self.down
    remove_index "events", ["last_date", "frequency", "has_class"]
  end
end

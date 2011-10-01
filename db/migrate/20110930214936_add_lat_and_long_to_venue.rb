class AddLatAndLongToVenue < ActiveRecord::Migration
  def self.up
    add_column :venues, :lat, :decimal, :precision => 15, :scale => 10
    add_column :venues, :long, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :venues, :long
    remove_column :venues, :lat
  end
end

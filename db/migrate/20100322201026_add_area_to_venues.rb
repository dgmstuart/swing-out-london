class AddAreaToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :area, :string
  end

  def self.down
    remove_column :venues, :area
  end
end

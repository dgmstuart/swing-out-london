class AddOrganiserIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :organiser_id, :integer
  end

  def self.down
    remove_column :events, :organiser_id
  end
end

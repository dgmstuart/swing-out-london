class RemoveFrequencyFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :frequency
  end

  def self.down
    add_column :events, :frequency, :string
  end
end

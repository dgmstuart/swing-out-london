class AddFrequencyToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :frequency, :integer
    add_column :events, :week_in_month, :integer
  end

  def self.down
    drop_column :events, :frequency
    drop_column :events, :week_in_month
  end
end

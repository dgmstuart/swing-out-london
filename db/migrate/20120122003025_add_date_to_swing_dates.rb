class AddDateToSwingDates < ActiveRecord::Migration
  def self.up
    add_column :swing_dates, :date, :date
  end

  def self.down
    remove_column :swing_dates, :date
  end
end

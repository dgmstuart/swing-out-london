class DropUnusedTables < ActiveRecord::Migration
  def change
    drop_table :organisers
    drop_table :swing_dates
    drop_table :events_swing_dates
    drop_table :events_swing_cancellations
  end
end

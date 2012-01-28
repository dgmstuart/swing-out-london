class CreateEventsSwingDates < ActiveRecord::Migration
  def self.up
    create_table :events_swing_dates, :id => false do |t|
      t.integer :swing_date_id, :null => false
      t.integer :event_id, :null => false
    end

    add_index :events_swing_dates, [:swing_date_id, :event_id], :unique => true
  end

  def self.down
    remove_index :events_swing_dates, [:swing_date_id, :event_id]
    drop_table :events_swing_dates
  end
end
# frozen_string_literal: true

class CreateEventsSwingCancellations < ActiveRecord::Migration
  def self.up
    create_table :events_swing_cancellations, id: false do |t|
      t.integer :swing_date_id, null: false
      t.integer :event_id, null: false
    end

    add_index :events_swing_cancellations, %i[swing_date_id event_id], unique: true
  end

  def self.down
    remove_index :events_swing_cancellations, %i[swing_date_id event_id]
    drop_table :events_swing_cancellations
  end
end

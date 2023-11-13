# frozen_string_literal: true

class CreateEventInstances < ActiveRecord::Migration[7.1]
  def change
    create_table :event_instances do |t|
      t.references :event, null: false, foreign_key: true, index: false
      t.date :date, null: false

      t.timestamps
    end

    add_index :event_instances, :date
    add_index :event_instances, %i[event_id date], unique: true
  end
end

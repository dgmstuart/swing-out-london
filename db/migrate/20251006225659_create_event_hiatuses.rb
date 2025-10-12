# frozen_string_literal: true

class CreateEventHiatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :event_hiatuses do |t|
      t.references :event, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :return_date, null: false

      t.timestamps
    end
  end
end

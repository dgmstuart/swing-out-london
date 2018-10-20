# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.string :day
      t.string :frequency
      t.string :popularity
      t.string :dressup_level
      t.float :male_female_ratio
      t.string :event_type

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

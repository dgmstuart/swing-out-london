# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :title
      t.string :activity_type
      t.string :style
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end

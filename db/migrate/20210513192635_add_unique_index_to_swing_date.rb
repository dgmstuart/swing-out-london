# frozen_string_literal: true

class AddUniqueIndexToSwingDate < ActiveRecord::Migration[5.2]
  def change
    add_index :swing_dates, :date, unique: true
  end
end

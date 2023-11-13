# frozen_string_literal: true

class RemoveUnusedColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :events, bulk: true do |t|
      t.remove :event_type, type: :string
      t.remove :date_array, type: :string
      t.remove :cancellation_array, type: :string
      t.remove :expected_date, type: :date
    end

    change_table :venues, bulk: true do |t|
      t.remove :compass, type: :string
    end
  end
end

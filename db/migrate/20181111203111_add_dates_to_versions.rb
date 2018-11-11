# frozen_string_literal: true

class AddDatesToVersions < ActiveRecord::Migration[5.2]
  def change
    change_table :versions, bulk: true do |t|
      t.string :dates
      t.string :cancellations
    end
  end
end

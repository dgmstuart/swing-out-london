# frozen_string_literal: true

class AddCancellationToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :cancellation_array, :string
    add_column :events, :first_date, :date
    add_column :events, :last_date, :date
  end

  def self.down
    remove_column :events, :last_date
    remove_column :events, :first_date
    remove_column :events, :cancellation_array
  end
end

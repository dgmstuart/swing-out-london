# frozen_string_literal: true

class AddExpectedDateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :expected_date, :date
  end
end

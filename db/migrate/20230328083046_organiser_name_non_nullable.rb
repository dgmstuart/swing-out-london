# frozen_string_literal: true

class OrganiserNameNonNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :organisers, :name, false
  end
end

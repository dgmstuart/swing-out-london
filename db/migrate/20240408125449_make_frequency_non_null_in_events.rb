# frozen_string_literal: true

class MakeFrequencyNonNullInEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_null :events, :frequency, false
  end
end

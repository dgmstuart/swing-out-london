# frozen_string_literal: true

class EventUrlNonNillable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :url, false
  end
end

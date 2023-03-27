# frozen_string_literal: true

class EventVenueNonNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :venue_id, false
  end
end

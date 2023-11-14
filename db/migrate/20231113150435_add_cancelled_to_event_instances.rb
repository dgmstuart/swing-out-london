# frozen_string_literal: true

class AddCancelledToEventInstances < ActiveRecord::Migration[7.1]
  def change
    add_column :event_instances, :cancelled, :boolean, null: false, default: false
  end
end

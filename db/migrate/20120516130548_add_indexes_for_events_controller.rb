# frozen_string_literal: true

class AddIndexesForEventsController < ActiveRecord::Migration
  def self.up
    add_index 'events', %w[last_date event_type]
  end

  def self.down
    remove_index 'events', %w[last_date event_type]
  end
end

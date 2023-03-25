# frozen_string_literal: true

class AddFinalIndexesToEvents < ActiveRecord::Migration
  def self.up
    add_index "events", %w[frequency has_class]
  end

  def self.down
    remove_index "events", %w[frequency has_class]
  end
end

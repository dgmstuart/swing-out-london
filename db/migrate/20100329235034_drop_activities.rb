# frozen_string_literal: true

class DropActivities < ActiveRecord::Migration
  def self.up
    drop_table :activities
  end

  def self.down; end
end

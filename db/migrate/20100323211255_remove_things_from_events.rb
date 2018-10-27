# frozen_string_literal: true

class RemoveThingsFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :popularity
    remove_column :events, :male_female_ratio
    remove_column :events, :dressup_level
    remove_column :events, :skill_level
    remove_column :events, :start_hours
    remove_column :events, :start_minutes
    remove_column :events, :end_hours
    remove_column :events, :end_minutes
    remove_column :events, :week_in_month
  end

  def self.down; end
end

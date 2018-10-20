# frozen_string_literal: true

class AddHasSocialClassTasterToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :has_taster, :boolean
    add_column :events, :has_class, :boolean
    add_column :events, :has_social, :boolean
  end

  def self.down
    remove_column :events, :has_taster
    remove_column :events, :has_class
    remove_column :events, :has_social
  end
end

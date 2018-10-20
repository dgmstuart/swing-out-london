# frozen_string_literal: true

class AddCompassToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :compass, :string
  end

  def self.down
    remove_column :venues, :compass
  end
end

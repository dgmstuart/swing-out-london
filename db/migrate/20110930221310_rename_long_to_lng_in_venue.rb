# frozen_string_literal: true

class RenameLongToLngInVenue < ActiveRecord::Migration
  def self.up
    rename_column :venues, :long, :lng
  end

  def self.down
    rename_column :venues, :lng, :long
  end
end

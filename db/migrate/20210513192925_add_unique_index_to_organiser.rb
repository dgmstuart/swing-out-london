# frozen_string_literal: true

class AddUniqueIndexToOrganiser < ActiveRecord::Migration[5.2]
  def change
    add_index :organisers, :shortname, unique: true
  end
end

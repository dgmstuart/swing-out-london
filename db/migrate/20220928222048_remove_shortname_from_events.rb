# frozen_string_literal: true

class RemoveShortnameFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :shortname, :string
  end
end

# frozen_string_literal: true

class AddOrganiserTokenIndexToEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :events, :organiser_token, unique: true
  end
end

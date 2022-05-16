# frozen_string_literal: true

class AddOrganiserTokenToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :organiser_token, :string
  end
end

# frozen_string_literal: true

class AddUserNameToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :user_name, :string
  end
end

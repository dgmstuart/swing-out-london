# frozen_string_literal: true

class ChangeAuditsCommentFromStringToText < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        change_column :audits, :comment, :text
      end
      dir.down do
        change_column :audits, :comment, :string
      end
    end
  end
end

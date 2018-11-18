# frozen_string_literal: true

class ChangeAuditUsernameToJsonb < ActiveRecord::Migration[5.2]
  def change
    reversible do |change|
      change.up { change_column :audits, :username, 'jsonb USING username::jsonb' }
      change.down { change_column :audits, :username, :string }
    end
  end
end

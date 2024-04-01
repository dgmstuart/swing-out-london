# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[7.1]
  def up
    create_table :roles do |t|
      t.string :facebook_ref, null: false
      t.string :role, default: "editor", null: false

      t.timestamps
    end

    add_index :roles, :facebook_ref, unique: true

    admin_user_ids = ENV.fetch("ADMIN_USER_IDS", "").split(",")
    editor_user_ids = ENV.fetch("EDITOR_USER_IDS", "").split(",")

    admin_user_ids.each { |facebook_ref| create_role(facebook_ref:, role: "admin") }
    editor_user_ids.each { |facebook_ref| create_role(facebook_ref:, role: "editor") }
  end

  def down
    remove_index :roles, :facebook_ref
    drop_table :roles
  end

  private

  def create_role(facebook_ref:, role:)
    execute(<<~SQL.squish)
      INSERT INTO roles (facebook_ref, role, created_at, updated_at)
      VALUES ('#{facebook_ref}', '#{role}', NOW(), NOW())
    SQL
  end
end

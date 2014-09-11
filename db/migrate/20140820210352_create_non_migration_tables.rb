class CreateNonMigrationTables < ActiveRecord::Migration
  # Tables which aren't having data migrated into them
  def change
    create_table "event_instances", force: true do |t|
      t.date     "date",          null: false
      t.integer  "event_seed_id", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "url"
      t.integer  "venue_id"
    end

    create_table "users", force: true do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
